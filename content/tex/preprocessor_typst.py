#!/usr/bin/env python3
"""Preprocessor that generates self-contained Typst code from C++ source files."""

import sys, os, re


def typst_escape(text):
    """Escape special chars for Typst content blocks."""
    text = text.replace("\\", "\\\\")
    text = text.replace("*", "\\*")
    text = text.replace("_", "\\_")
    text = text.replace("#", "\\#")
    text = text.replace("<", "\\<")
    text = text.replace(">", "\\>")
    text = text.replace("//", "\\/\\/")
    text = text.replace("[", "\\[")
    text = text.replace("]", "\\]")
    return text


def typst_escape_preserve_mi(text):
    """Escape Typst special chars but preserve #mi(`...`) and #box(image(...)) calls."""
    parts = re.split(r"(#mi\(`[^`]*`\)|#box\(image\([^)]*\)\))", text)
    result = []
    for part in parts:
        if part.startswith("#mi(") or part.startswith("#box("):
            result.append(part)
        else:
            result.append(typst_escape(part))
    return "".join(result)


def typst_str_escape(text):
    """Escape for Typst strings."""
    text = text.replace("\\", "\\\\")
    text = text.replace('"', '\\"')
    return text


def convert_texttt(text):
    """Convert \\texttt{...} and {\\tt ...} to Typst mono code."""
    text = re.sub(r"\\texttt\{([^}]*)\}", r"`\1`", text)
    text = re.sub(r"\{\\tt\s+([^}]*)\}", r"`\1`", text)
    return text


def convert_latex_envs(text):
    r"""Strip layout-only LaTeX environments and convert \includegraphics to Typst images."""
    text = re.sub(r"\\begin\{minipage\}\{[^}]*\}", "", text)
    text = re.sub(r"\\end\{minipage\}", "", text)
    text = re.sub(r"\\begin\{itemize\*?\}", "", text)
    text = re.sub(r"\\end\{itemize\*?\}", "", text)
    text = re.sub(r"\\vspace\{[^}]*\}", "", text)
    text = re.sub(r"\\item\s*", "• ", text)
    text = re.sub(
        r"\\includegraphics\[[^\]]*\]\{([^}]*)\}",
        r'#box(image("/\1.pdf", width: 12mm))',
        text,
    )
    text = re.sub(r"\\\\\s*", " ", text)  # LaTeX line breaks -> space
    return text


def convert_math_to_mi(text):
    """Convert $...$ LaTeX math to #mi(`...`) calls for Typst rendering."""

    def replace_inline(m):
        math_content = m.group(1).strip()
        return f"#mi(`{math_content}`)"

    text = re.sub(r"\$([^$]+)\$", replace_inline, text)
    return text


def convert_latex_macros(text):
    r"""Convert remaining LaTeX macros that appear outside #mi(...) math.

    Handles \_, \%, \ensuremath{}, \tilde{}, \log, \sqrt, \textbf{} etc.
    Skips content inside #mi(...) boundaries.
    """
    parts = re.split(r"(#mi\(`[^`]*`\))", text)
    result = []
    for part in parts:
        if part.startswith("#mi("):
            result.append(part)
            continue
        # Math commands outside $...$ -> wrap in #mi()
        # \log (expr) -> \log(expr), \log var -> \log{var}, bare \log -> \log
        part = re.sub(r"\\log\s*\(([^)]*)\)", r"#mi(`\\log(\1)`)", part)  # \log (expr)
        part = re.sub(r"\\log(?:\s+([a-zA-Z]))", r"#mi(`\\log{\1}`)", part)  # \log var
        # \max(var) -> \max(var) (no bare \max fallback to avoid nesting)
        part = re.sub(r"\\max\s*\(([^)]*)\)", r"#mi(`\\max(\1)`)", part)  # \max (expr)
        # \sqrt Q -> \sqrt{Q} then wrap
        part = re.sub(r"\\sqrt\s*(\w)", r"#mi(`\\sqrt{\1}`)", part)
        # Text formatting
        part = re.sub(r"\\textbf\{([^}]*)\}", r"*\1*", part)  # \textbf{x} -> *x* (bold)
        part = re.sub(r"\\emph\{([^}]*)\}", r"_\1_", part)  # \emph{x} -> _x_ (italic)
        part = re.sub(r"\\_", "_", part)  # \_ -> _
        part = re.sub(r"\\%", "%", part)  # \% -> %
        part = re.sub(r"\\{", "{", part)  # \{ -> { (LaTeX literal brace)
        part = re.sub(r"\\}", "}", part)  # \} -> }
        part = re.sub(r"\\tilde\{([^}]*)\}", "\u223c", part)  # \tilde{x} -> ∼
        part = re.sub(r"\\tilde\b(?![{\\])", "\u223c", part)  # bare \tilde -> ∼
        part = re.sub(r"\\ensuremath\{>}", ">", part)  # \ensuremath{>} -> >
        part = re.sub(r"\\ensuremath\{<}", "<", part)  # \ensuremath{<} -> <
        result.append(part)
    return "".join(result)


def parse_header(lines):
    """Parse /** ... */ comment header from source lines.

    Matches original KACTL behavior: multi-line values are accumulated.
    Lines starting with * that don't have Key: format are appended to the
    previous command's value.

    Strips ALL /** ... */ blocks from the code.
    Returns (commands_dict, remaining_code, has_header).
    """
    text = "\n".join(lines)

    # Extract the first /** ... */ block for commands
    m = re.search(r"/\*\*(.*?)\*/", text, re.DOTALL)
    if not m:
        return {}, text.strip(), False

    header = m.group(1)
    commands = {}
    current_key = None
    current_val = ""

    for line in header.split("\n"):
        stripped = line.strip().lstrip("*").strip()
        if not stripped:
            continue
        # Check if this line starts a new Key: Value pair
        if ":" in stripped and stripped[0].isalpha() and stripped[0].isupper():
            colon_pos = stripped.find(":")
            key_candidate = stripped[:colon_pos].strip()
            # Verify it's a proper key (no spaces, starts with uppercase)
            if " " not in key_candidate:
                # Save previous key-value pair
                if current_key:
                    commands[current_key] = current_val.lstrip()
                current_key = key_candidate
                current_val = stripped[colon_pos + 1 :].strip()
            else:
                # Continuation of previous value
                if current_key:
                    current_val += "\n" + stripped
        else:
            # Continuation of previous value
            if current_key:
                current_val += "\n" + stripped

    # Save last key-value pair
    if current_key:
        commands[current_key] = current_val.lstrip()

    # Remove ALL /** ... */ blocks from the code
    code = re.sub(r"/\*\*.*?\*/", "", text, flags=re.DOTALL).strip()

    return commands, code, True


def preprocess_keep_include(lines):
    """Handle keep-include markers before comment stripping.

    Lines containing /** keep-include */ need to keep their #include
    in the code listing. We strip the comment but add a marker
    so clean_code knows to keep the include.
    """
    result = []
    for line in lines:
        if "keep-include" in line:
            # Strip the /** keep-include */ comment, keep the #include
            line = re.sub(r"\s*/\*\*\s*keep-include\s*\*/", "", line).rstrip()
            # Add a sentinel so clean_code knows to keep this include
            line = line + " KACTL_KEEP_INCLUDE"
        result.append(line)
    return result


def clean_code(lines):
    """Clean source code: remove pragmas, filter includes, handle comments.

    Matches original KACTL preprocessor behavior:
    - exclude-line: skip entirely
    - include-line: uncomment and keep
    - All #include lines: extract to includes list, remove from code
      UNLESS KACTL_KEEP_INCLUDE sentinel is present (keep in code, don't add to list)
    - /// (triple-slash) comments: strip, but keep // (double-slash) comments
    - #pragma once: remove
    - Blank lines after /// stripping: remove
    """
    cleaned = []
    includes = []
    for line in lines:
        if "exclude-line" in line:
            continue
        if "include-line" in line:
            line = line.replace("// ", "", 1)

        # Check for keep-include sentinel (set by preprocess_keep_include)
        keep_include = "KACTL_KEEP_INCLUDE" in line
        if keep_include:
            line = line.replace("KACTL_KEEP_INCLUDE", "").rstrip()

        # Only strip /// (triple-slash) comments, NOT // (double-slash) comments
        had_comment = "///" in line
        comment_start = line.find("///")
        if comment_start >= 0:
            line = line[:comment_start].rstrip()

        if not line.strip():
            continue
        if line.strip() == "#pragma once":
            continue

        # Handle #include lines
        include_local = re.match(r'#include\s+"(.+)"', line.strip())
        include_sys = re.match(r"#include\s+[<](.+)[>]", line.strip())
        include = include_local or include_sys

        if include:
            if keep_include:
                # Keep in code, don't add to includes list
                pass
            else:
                # Extract to includes list, remove from code
                includes.append(include.group(1))
                continue

        cleaned.append(line)
    return cleaned, includes


def hash_code(code):
    """Compute hash of code ignoring whitespace."""
    import hashlib

    try:
        h = hashlib.md5(code.encode("utf-8"))
        return h.hexdigest()[:6] + ", "
    except:
        return ""


def process_file(filepath, outpath):
    """Process a single C++ header/source file."""
    with open(filepath, "r") as f:
        content = f.read()

    # Preserve keep-include lines before comment stripping
    raw_lines = content.split("\n")
    raw_lines = preprocess_keep_include(raw_lines)

    # Parse the /** ... */ header block and get the code after it
    commands, code_after_header, has_header = parse_header(raw_lines)

    # Clean the code (after header removal), using lines from the stripped code
    cleaned, includes = clean_code(code_after_header.split("\n"))
    code = "\n".join(cleaned)
    code = code.strip()

    # Determine language
    ext = os.path.splitext(filepath)[1].lower()
    lang_map = {".cpp": "cpp", ".cc": "cpp", ".c": "cpp", ".h": "cpp", ".hpp": "cpp"}
    lang = lang_map.get(ext, "cpp")

    # Hash only for C++ files (matching original KACTL behavior)
    if ext in lang_map:
        hsh = hash_code(code)
    else:
        hsh = ""

    num_lines = len(cleaned)

    # Validate commands only when a header block exists
    warnings = []
    errors = []
    if has_header:
        knowncommands = [
            "Author",
            "Date",
            "Description",
            "Source",
            "Time",
            "Memory",
            "License",
            "Status",
            "Usage",
            "Details",
        ]
        requiredcommands = ["Author", "Description"]
        for cmd in commands:
            if cmd not in knowncommands:
                warnings.append(f"Unknown command: {cmd}")
        for rcmd in sorted(set(requiredcommands) - set(commands)):
            errors.append(f"Missing command: {rcmd}")

    caption = os.path.basename(filepath)

    # Build Typst output - matching original KACTL listing style
    # Layout: filename → metadata → includes+hash → top rule → code
    with open(outpath, "w") as f:
        f.write('#import "@preview/mitex:0.2.7": mi, mitex\n')
        # Register filename for header (uses global state)
        f.write(f"#context {{\n")
        f.write(f"  let p = counter(page).get().first()\n")
        f.write(
            f'  state("kactl-files", ()).update(regs => regs + (("{typst_str_escape(caption)}", p),))\n'
        )
        f.write(f"}}\n")
        # Emit warnings and errors (matching LaTeX \kactlwarning / \kactlerror)
        for w in warnings:
            f.write(
                f"#block(width: 100%, fill: orange.lighten(80%))[{typst_escape(caption)}: {typst_escape(w)}]\\\n"
            )
        for e in errors:
            f.write(
                f"#block(width: 100%, fill: red.lighten(80%))[{typst_escape(caption)}: {typst_escape(e)}]\\\n"
            )
        # Filename in large font on its own line (matching LaTeX \large)
        f.write(f'#text(size: 12pt, weight: "bold")[{typst_escape(caption)}]\\\n')

        # Metadata before the code (matching LaTeX \@makecaption called before body)
        desc = commands.get("Description", "")
        if desc:
            desc = convert_latex_envs(desc)
            desc = convert_texttt(desc)
            desc = convert_math_to_mi(desc)
            desc = convert_latex_macros(desc)
            desc_escaped = typst_escape_preserve_mi(desc)
            f.write(f"#text(size: 8pt)[*Description:* {desc_escaped}]\\\n")

        usage = commands.get("Usage", "")
        if usage:
            usage = convert_latex_envs(usage)
            usage = convert_texttt(usage)
            usage = convert_math_to_mi(usage)
            usage = convert_latex_macros(usage)
            usage_escaped = typst_escape_preserve_mi(usage)
            f.write(f"#text(size: 8pt)[*Usage:* {usage_escaped}]\\\n")

        mem = commands.get("Memory", "")
        if mem:
            mem = convert_texttt(mem)
            mem = convert_math_to_mi(mem)
            mem = convert_latex_macros(mem)
            mem_escaped = typst_escape_preserve_mi(mem)
            f.write(f"#text(size: 8pt)[*Memory:* {mem_escaped}]\\\n")

        tim = commands.get("Time", "")
        if tim:
            tim = convert_texttt(tim)
            tim = convert_math_to_mi(tim)
            tim = convert_latex_macros(tim)
            tim_escaped = typst_escape_preserve_mi(tim)
            f.write(f"#text(size: 8pt)[*Time:* {tim_escaped}]\\\n")

        # Includes + hash on same line, with bottom rule (replacing LaTeX lstlisting frame=t)
        if includes:
            f.write(
                f'#block(stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#text(size: 5.5pt, font: "TeX Gyre Cursor")[{typst_escape(", ".join(includes))}]#h(1fr)#text(size: 5.5pt, style: "italic")[{hsh}{num_lines} lines]]\n'
            )
        else:
            f.write(
                f'#block(stroke: (bottom: 0.5pt), inset: (bottom: 5pt))[#h(1fr)#text(size: 5.5pt, style: "italic")[{hsh}{num_lines} lines]]\n'
            )

        # Code block
        f.write(
            "#block(width: 100%, below: 0pt, inset: (top: 3pt, bottom: 2pt, left: 4pt, right: 4pt))[\n"
        )
        escaped_code = typst_str_escape(code)
        f.write(f'  #text(size: 8pt, raw("{escaped_code}", lang: "{lang}"))\n')
        f.write("]\n")  # close code block
        # Spacing between snippets
        f.write("#v(0.5em)\n")


if __name__ == "__main__":
    if len(sys.argv) >= 3:
        process_file(sys.argv[1], sys.argv[2])
    elif len(sys.argv) == 2 and sys.argv[1] == "--batch":
        import os

        content_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..")
        build_dir = os.path.join(content_dir, "build")
        for root, dirs, files in os.walk(content_dir):
            for f in sorted(files):
                if not (f.endswith(".cpp") or f.endswith(".h")):
                    continue
                filepath = os.path.join(root, f)
                # Flatten: use just the basename (matching old Makefile approach)
                outpath = os.path.join(build_dir, f + ".typ")
                os.makedirs(build_dir, exist_ok=True)
                process_file(filepath, outpath)
    else:
        print("Usage: preprocessor_typst.py <input.cpp> <output.typ>")
        print("       preprocessor_typst.py --batch")
        sys.exit(1)
