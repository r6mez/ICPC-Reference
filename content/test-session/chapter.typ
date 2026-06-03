= Test session

== To test during test session
- Keyboard layouts
- vimrc
- template.cpp
- Python
- Printing
- Sending clarifications
- Documentation
- Submit script
- Whitespace/case insensitivity in output
- Return values from main
- Printing to stderr
- Source code limit
- Is it possible to submit and read from non-source files?
- All judge errors:
  - Accepted
  - WA
  - Presentation Error
  - RTE (what results in RTE?)
  - TLE
  - Memory limit, both stack and heap
  - Output limit
  - Illegal function
  - Compile error
  - Compile time limit exceeded
  - Compile memory limit exceeded
  - Too late
- Listing all available binaries \
  `echo $PATH | tr ':' ' ' | xargs ls | grep -v / | sort | uniq | tr '\n' ' ' > path.txt`