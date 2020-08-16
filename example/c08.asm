	ADR PROGRAM
PROGRAM
	TST '.SYNTAX'
	BF L1
	ID
	BE
	LB
	CL '// '
	CI
	CL ' compiler'
	NL
	CL 'function compiler (input) {'
	LMI
	NL
	CL 'inbuf = input ;'
	NL
	CL 'inp = 0 ;'
	NL
	CL 'outbuf = "" ;'
	NL
	CL 'margin = 0 ;'
	NL
	CL 'gnlabel = 1 ;'
	NL
	CL 'rule'
	CI
	CL '() ;'
	NL
	CL 'return outbuf ;'
	NL
	LMD
	CL '} ;'
	NL
	NL
L2
	CLL ST
	BT L2
	SET
	BE
	TST '.END'
	BE
L1
L3
	R
ST
	ID
	BF L4
	LB
	CL 'function rule'
	CI
	CL ' () {'
	LMI
	NL
	CL 'var rname = "'
	CI
	CL '" ;'
	NL
	CL 'var rlabel = 0 ;'
	NL
	TST '='
	BE
	CLL EX1
	BE
	TST ';'
	BE
	LMD
	CL '} ;'
	NL
	NL
L4
L5
	R
EX1
	CLL EX2
	BF L6
L7
	TST '/'
	BF L8
	CL 'if (!flag) {'
	LMI
	NL
	CLL EX2
	BE
	LMD
	CL '} ;'
	NL
L8
L9
	BT L7
	SET
	BE
L6
L10
	R
EX2
	CLL EX3
	BF L11
	CL 'if (flag) {'
	LMI
	NL
L11
	BT L12
	CLL OUTPUT
	BF L13
	CL 'if (true) {'
	LMI
	NL
L13
L12
	BF L14
L15
	CLL EX3
	BF L16
	CL 'if (!flag) runBEjsfn(rname);'
	NL
L16
	BT L17
	CLL OUTPUT
	BF L18
L18
L17
	BT L15
	SET
	BE
	LMD
	CL '} ;'
	NL
L14
L19
	R
EX3
	ID
	BF L20
	CL 'rule'
	CI
	CL '();'
	NL
L20
	BT L21
	SR
	BF L22
	CL 'runTST('
	CI
	CL ');'
	NL
L22
	BT L21
	TST '.ID'
	BF L23
	CL 'runID();'
	NL
L23
	BT L21
	TST '.NUMBER'
	BF L24
	CL 'runNUM();'
	NL
L24
	BT L21
	TST '.STRING'
	BF L25
	CL 'runSR();'
	NL
L25
	BT L21
	TST '('
	BF L26
	CLL EX1
	BE
	TST ')'
	BE
L26
	BT L21
	TST '.EMPTY'
	BF L27
	CL 'runSET();'
	NL
L27
	BT L21
	TST '$'
	BF L28
	CL 'runSET();'
	NL
	CL 'while (flag) {'
	LMI
	NL
	CLL EX3
	BE
	CL '};'
	LMD
	NL
	CL 'runSET();'
	NL
L28
L21
	R
OUTPUT
	TST '.OUT'
	BF L29
	TST '('
	BE
L30
	CLL OUT1
	BT L30
	SET
	BE
	TST ')'
	BE
L29
L31
	R
OUT1
	TST '*'
	BF L32
	CL 'runCI();'
	NL
L32
	BT L33
	SR
	BF L34
	CL 'runCL('
	CI
	CL ');'
	NL
L34
	BT L33
	TST '#'
	BF L35
	CL 'if (rlabel == 0) { rlabel = gnlabel; gnlabel++ ; } ;'
	NL
	CL 'runCL(rlabel.toString());'
	NL
L35
	BT L33
	TST '.NL'
	BF L36
	CL 'runextNL();'
	NL
L36
	BT L33
	TST '.LB'
	BF L37
	CL 'runLB();'
	NL
L37
	BT L33
	TST '.TB'
	BF L38
	CL 'runextTB();'
	NL
L38
	BT L33
	TST '.LM+'
	BF L39
	CL 'runextLMI();'
	NL
L39
	BT L33
	TST '.LM-'
	BF L40
	CL 'runextLMD();'
	NL
L40
L33
	R
	END
