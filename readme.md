# Introduction
This project implements the [META-II][1] compiler language
described by Schorre in his [1963 paper][2]

[1]: https://en.wikipedia.org/wiki/META_II "Meta II"
[2]: http://www.ibm-1401.info/Meta-II-schorre.pdf 
  "A Syntax-Oriented Compiler Writing Language"

## META II Syntax

### META II Constructs
.ID - Recognize an identifier
.NUMBER - Recognize a number
.STRING - Recognize any string in single quotes
string in single quotes - Recognize the given string
rule name  - Recognize the given syntax rule
A / B - Recognize A or B
A B - Recognize A and B
.EMPTY - Recognize nothing, always succeed
$A - Repeat A until not recognized
(A B) - Group recognition constructs

### META II Output
.OUT() - Output a text line
.OUT('string') - Output a literal string
.OUT(\*) - Output last recognized token
.OUT(\*1) - Output generated number 1
.OUT(\*2) - Output generated number 2
.LABEL 'string' - Output a literal string at left margin
.LABEL \* - Output last recognized token at left margin
.LABEL \*1 - Output generated number 1 at left margin
.LABEL \*2 - Output generated number 2 at left margin

### META II Opcodes
#### Base machine
TST 'string' - Test for input string
: After skipping initial whitespace in the input, compare
  the input to the given string. If it matches, skip over
  the string in the input and set the switch. If not met,
  reset switch.
ID - Identifier token
: After skipping initial whitespace, test if input begins
  with a sequence of letters and digits. If so, copy the
  identifier to the token buffer, skip over it in the
  input, and set switch. If not, reset switch.
NUM - Number token
: After skipping initial whitespace, test if input begins
  with a number (ie, a sequence of digits). If so, copy
  the number to the token buffer, skip over it in the
  input, and set the switch. If not, reset switch.
SR - String token
: After deleting initial whitespace in the input, test if
  it begins with the given string. If so, copy the string
  (with quotes) to the token buffer, skip over it in the
  input, and set switch. If not, reset switch.
CLL AAA - Call subroutine
: Enter subroutine at label AAA. Push a stackframe of three
  cells on the stack containing:
    1. Label 1 cell, initialized to blank
    2. Label 2 cell, initialized to blank
    3. Location cell, set to return from call location
R - Return from subroutine
: Return from CLL call to location on the top of the stack
  and pop the stackframe of three cells
SET - Set switch
: Set the switch to the true
B AAA - Unconditional branch
: Branch unconditionally to the label AAA
BT AAA - Branch if true
: If the switch is true, branch to label AAA
BF AAA - Branch if false
: If the switch is false, branch to label AAA
BE - Branch to error if false
: If the switch is false, report error status and halt
CL 'string' - Copy literal
: Copy the variable length string (without enclosing
  quotes) given as argument to the output buffer
CI - Copy input
: Copy the token buffer to the output buffer
GN1 - Generate label 1
: If the label 1 cell in the top stackframe is blank,
  then generate a unique label and save it in the label 1
  cell. In either case output the label.
GN2 - Generate label 2
: Same as for GN1, except acting on the label 2 cell.
LB - Move to the label field
: Set the output buffer column to the first column
OUT - Output record
: Output the output buffer with line terminator; clear it,
  and set the output buffer column to the eighth column.

#### Pseudo-opcodes
ADR AAA - Starting location
: Pseudo operation that specifies the starting label.
END - End of source
: Specifies the end of input

#### Margin width extension opcodes
GN - Unique number
: If the label 1 cell at the stack top is blank, generate
  a unique number and save it in the label 1 cell. In
  either case output the label.
NL - Newline
: Flush output buffer with ending newline and move to left
  margin
LB - Label field
: Move to output column 1
TB - Tab
: Move to the next tab stop
LMI - Left margin increase
: Increase the left margin, indenting block
LMD - Left margin decrease
: Decrease the left margin, outdenting block

#### Finer-grained token rules extension opcodes
CC number
: Copy char code to output
RF
: Return from rule if parse flag false
TFT
: Set token flag true and clear token
TFF
: Set token flag false
NOT
: Parse flag set to not parse flag
SCN
: If parse flag, scan input character. If token flag, add
  to token.
CGE number
: Parse flag set to input char code >= number
CLE number
: Parse flag set to input char code <= number
CE number
: Parse flag set to input char code == number
LCH number
: Set parse flag, place char code as a string in token
  buffer

### Warnings and pitfalls
This parser cannot (yet) handle rules that require back-
tracking. Also, any kind of left-duplication, such as
left-recursion or alternatives sharing identical first
items, will lead to errors. Left-recursion should trigger
the infinite recursion detector, and left-duplication will
trigger a premature exit.

## TODO
- [ ] Better error handling on left-duplication.
- [ ] Verify infinite recursion detector works on left-
      recursion.
- [x] Add comments to grammar (covered in tutorial?)
      Finished: implemented in i13 of tutorial
- [x] Update metaii.perl to allow asm comments, indicated
      by leading ';' on each comment line. Finished: 
      implemented in i14 of tutorial.
- [ ] Implement backtracking.
