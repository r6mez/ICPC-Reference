#!/usr/bin/env python3
"""Translate LaTeX chapter.tex files to Typst chapter.typ files using mitex for math."""

import re
import sys
import os


def escape_typst_text(text):
    """Escape special Typst characters in plain text."""
    # Don't escape things inside mitex/mi calls
    text = text.replace('#', '\\#')
    return text


def process_chapter(content):
    """Process a LaTeX chapter file and convert to Typst using mitex."""
    
    # ===== PHASE 1: Extract and protect math blocks =====
    math_blocks = {}
    counter = [0]
    
    def make_placeholder(tex_content, kind='display'):
        key = f'\x00MATH{counter[0]}\x00'
        counter[0] += 1
        math_blocks[key] = (tex_content, kind)
        return key
    
    # 1a. Extract \begin{align*}...\end{align*} blocks
    # These are multi-line, so we need DOTALL
    def extract_align(m):
        body = m.group(1)
        return make_placeholder(body, 'align')
    content = re.sub(
        r'\\begin\{align\*\}(.*?)\\end\{align\*\}',
        extract_align, content, flags=re.DOTALL
    )
    
    # 1b. Extract $$...$$ display math (before $...$ inline)
    def extract_doubledollar(m):
        body = m.group(1).strip()
        return make_placeholder(body, 'display')
    content = re.sub(r'\$\$(.*?)\$\$', extract_doubledollar, content, flags=re.DOTALL)
    
    # 1c. Extract \[...\] display math
    def extract_bracket(m):
        body = m.group(1).strip()
        return make_placeholder(body, 'display')
    content = re.sub(r'\\\[(.*?)\\\]', extract_bracket, content, flags=re.DOTALL)
    
    # 1d. Extract $...$ inline math
    # Match $...$ but not $$...$$ and not inside math placeholders
    # Need to be careful: $...$ should not span across blank lines
    def extract_inline(m):
        body = m.group(1).strip()
        return make_placeholder(body, 'inline')
    # Use a pattern that matches $ at word boundary, then minimal content, then $ 
    # Avoid matching $$ or \[ \]
    content = re.sub(r'(?<!\$)\$(?!\$)((?:[^$]|\\\$)*?)(?<!\$)\$(?!\$)', extract_inline, content)
    
    # ===== PHASE 2: Structure translations =====
    
    # \kactlimport{...} or \kactlimport[options]{...}
    content = re.sub(
        r'\\kactlimport(?:\[[^\]]*\])?\{([^}]*)\}',
        lambda m: f'#include "/build/{m.group(1)}.typ"',
        content
    )
    
    # \import{...} → comment
    content = re.sub(r'\\import\{([^}]*)\}', lambda m: f'// import: {m.group(1)}', content)
    
    # \chapter{...} → = ...
    content = re.sub(r'\\chapter\{([^}]*)\}', r'= \1', content)
    
    # \section{...} → == ...
    content = re.sub(r'\\section\{([^}]*)\}', r'== \1', content)
    
    # \subsection{...} → === ...
    content = re.sub(r'\\subsection\{([^}]*)\}', r'=== \1', content)
    
    # \subsubsection{...} → ==== ...
    content = re.sub(r'\\subsubsection\{([^}]*)\}', r'==== \1', content)
    
    # \appendix → remove
    content = content.replace('\\appendix', '')
    content = content.replace('\\end{document}', '')
    
    # ===== PHASE 3: Text-mode translations =====
    
    # \texttt{...} → `...`
    content = re.sub(r'\\texttt\{([^}]*)\}', r'`\1`', content)
    
    # \textbf{...} → *...*
    content = re.sub(r'\\textbf\{([^}]*)\}', r'*\1*', content)
    
    # \emph{...} → _..._
    content = re.sub(r'\\emph\{([^}]*)\}', r'_\1_', content)
    
    # \textrm{...} → just the content (roman text in math)
    content = re.sub(r'\\textrm\{([^}]*)\}', r'\1', content)
    
    # \verb@...@ → `...`
    content = re.sub(r'\\verb@([^@]*)@', r'`\1`', content)
    
    # \lstinline{...} → `...`
    content = re.sub(r'\\lstinline\{([^}]*)\}', r'`\1`', content)
    
    # \label{...} → remove
    content = re.sub(r'\\label\{[^}]*\}', '', content)
    
    # \small, \normalsize → remove
    content = content.replace('\\small', '')
    content = content.replace('\\normalsize', '')
    
    # \mkern-2mu → remove
    content = content.replace('\\mkern-2mu', '')
    
    # \, (thin space in text) → just space
    content = re.sub(r'\\,(?=[a-zA-Z])', ' ', content)
    
    # \quad, \qquad → spacing
    content = content.replace('\\quad', '  ')
    content = content.replace('\\qquad', '    ')
    
    # \includegraphics[width=25mm]{...} → #image("....png", width: 25mm)
    def replace_image(m):
        opts = m.group(1) or ''
        path = m.group(2)
        # Convert path to image path
        img_path = path + '.png' if not path.endswith('.png') else path
        if 'width' in opts:
            width_m = re.search(r'width\s*=\s*(\d+\w+)', opts)
            if width_m:
                return f'#image("{img_path}", width: {width_m.group(1)})'
        return f'#image("{img_path}")'
    content = re.sub(r'\\includegraphics(?:\[([^\]]*)\])?\{([^}]*)\}', replace_image, content)
    
    # \begin{center}...\end{center} → #align(center)[...]
    def replace_center(m):
        body = m.group(1).strip()
        return f'#align(center)[\n{body}\n]'
    content = re.sub(r'\\begin\{center\}(.*?)\\end\{center\}', replace_center, content, flags=re.DOTALL)
    
    # \begin{itemize}[...]...\end{itemize} → bullet list
    def replace_itemize(m):
        body = m.group(1).strip()
        lines = body.split('\n')
        result = []
        for line in lines:
            line = re.sub(r'^(\s*)\\item\s*', lambda m: m.group(1) + '- ', line)
            result.append(line)
        return '\n'.join(result)
    content = re.sub(r'\\begin\{itemize\}(?:\[[^\]]*\])?(.*?)\\end\{itemize\}', replace_itemize, content, flags=re.DOTALL)
    
    # \begin{enumerate}...\end{enumerate} → numbered list
    def replace_enumerate(m):
        body = m.group(1).strip()
        lines = body.split('\n')
        result = []
        for line in lines:
            line = re.sub(r'^(\s*)\\item\s*', lambda m: m.group(1) + '+ ', line)
            result.append(line)
        return '\n'.join(result)
    content = re.sub(r'\\begin\{enumerate\}(?:\[[^\]]*\])?(.*?)\\end\{enumerate\}', replace_enumerate, content, flags=re.DOTALL)
    
    # \hline → --- (horizontal line)
    content = content.replace('\\hline', '---')
    
    # \\ at end of line (text mode line break) → Typst line break
    # Only outside of math placeholders
    content = re.sub(r'\\\\\s*\n', ' \\\n', content)
    content = re.sub(r'\\\\(?=\s|$)', ' \\\n', content)
    
    # ===== PHASE 4: Restore math blocks with mitex =====
    
    for key, (math_content, kind) in math_blocks.items():
        # Escape backticks in LaTeX content (very rare)
        escaped = math_content.replace('`', "'")
        
        if kind == 'inline':
            # Inline math: #mi(`...`)
            replacement = f'#mi(`{escaped}`)'
        elif kind == 'align':
            # align* environment: #mitex(`\begin{aligned}...\end{aligned}`)
            replacement = f'#mitex(`\\begin{{aligned}}{escaped}\\end{{aligned}}`)'
        elif kind == 'display':
            # Display math: #mitex(`...`)
            replacement = f'#mitex(`{escaped}`)'
        else:
            replacement = f'#mitex(`{escaped}`)'
        
        content = content.replace(key, replacement)
    
    # ===== PHASE 5: Clean up =====
    
    # Remove remaining \left, \right (should only appear in math now)
    # Remove empty lines that are just whitespace
    # Collapse multiple blank lines
    content = re.sub(r'\n{3,}', '\n\n', content)
    
    # Convert remaining % comments to //
    lines = content.split('\n')
    result_lines = []
    for line in lines:
        stripped = line.lstrip()
        if stripped.startswith('%'):
            result_lines.append('// ' + stripped[1:].strip())
        else:
            result_lines.append(line)
    content = '\n'.join(result_lines)
    
    # Don't remove \left/\right - mitex handles them correctly
    
    # Remove standalone \endgraf, \noindent, etc.
    content = content.replace('\\endgraf', '')
    content = content.replace('\\noindent', '')
    
    return content


def process_file(inpath, outpath):
    """Process a single .tex chapter file."""
    with open(inpath, 'r') as f:
        content = f.read()
    
    result = process_chapter(content)
    
    os.makedirs(os.path.dirname(outpath) if os.path.dirname(outpath) else '.', exist_ok=True)
    with open(outpath, 'w') as f:
        f.write(result)
    print(f'Processed {inpath} -> {outpath}')


if __name__ == '__main__':
    if len(sys.argv) >= 3:
        process_file(sys.argv[1], sys.argv[2])
    else:
        # Process all chapter.tex files
        base = os.path.dirname(os.path.abspath(__file__))
        for root, dirs, files in os.walk(os.path.join(base, 'content')):
            for f in sorted(files):
                if f == 'chapter.tex':
                    inpath = os.path.join(root, f)
                    outpath = os.path.join(root, 'chapter.typ')
                    print(f'Processing {inpath} -> {outpath}')
                    process_file(inpath, outpath)