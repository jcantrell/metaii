.SYNTAX PROGRAM

PROGRAM = '.SYNTAX' .ID .OUT('ADR ' *)
          $ ST 
          '.END' .OUT('END') ;

ST = .ID .LABEL * '=' EX1 ';' .OUT('R') ;

EX1 = EX2 $('/' .OUT('BT ' *1) EX2 )
      .LABEL *1 ;

EX2 = (EX3 .OUT('BF ' *1) / OUTPUT)
      $(EX3 .OUT('BE') / OUTPUT)
      .LABEL *1 ;

EX3 = .ID       .OUT('CLL '*) /
      .STRING   .OUT('TST '*) /
      '.ID'     .OUT('ID')    /
      '.NUMBER' .OUT('NUM')   /
      '.STRING' .OUT('SR')    /
      '(' EX1 ')'             /
      '.EMPTY'  .OUT('SET')   /
      '$' .LABEL *1 EX3 .OUT('BT ' *1) .OUT('SET') ;

OUTPUT = '.OUT' '('$OUT1 ')' ;

OUT1 = '*'     .OUT('CI')   / 
       .STRING .OUT('CL '*) /
       '#'     .OUT('GN')   /
       '.NL'   .OUT('NL')   /
       '.LB'   .OUT('LB')   /
       '.TB'   .OUT('TB')   /
       '.LM+'  .OUT('LMI')  /
       '.LM-'  .OUT('LMD')  ;

.END
	ADR PROGRAM
PROGRAM
	TST '.SYNTAX'
	BF L1
	ID
	BE
	CL 'ADR '
	CI
	OUT
L2
	CLL ST
	BT L2
	SET
	BE
	TST '.END'
	BE
	CL 'END'
	OUT
L1
L3
	R
ST
	ID
	BF L4
	LB
	CI
	OUT
	TST '='
	BE
	CLL EX1
	BE
	TST ';'
	BE
	CL 'R'
	OUT
L4
L5
	R
EX1
	CLL EX2
	BF L6
L7
	TST '/'
	BF L8
	CL 'BT '
	GN1
	OUT
	CLL EX2
	BE
L8
L9
	BT L7
	SET
	BE
	LB
	GN1
	OUT
L6
L10
	R
EX2
	CLL EX3
	BF L11
	CL 'BF '
	GN1
	OUT
L11
	BT L12
	CLL OUTPUT
	BF L13
L13
L12
	BF L14
L15
	CLL EX3
	BF L16
	CL 'BE'
	OUT
L16
	BT L17
	CLL OUTPUT
	BF L18
L18
L17
	BT L15
	SET
	BE
	LB
	GN1
	OUT
L14
L19
	R
EX3
	ID
	BF L20
	CL 'CLL '
	CI
	OUT
L20
	BT L21
	SR
	BF L22
	CL 'TST '
	CI
	OUT
L22
	BT L21
	TST '.ID'
	BF L23
	CL 'ID'
	OUT
L23
	BT L21
	TST '.NUMBER'
	BF L24
	CL 'NUM'
	OUT
L24
	BT L21
	TST '.STRING'
	BF L25
	CL 'SR'
	OUT
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
	CL 'SET'
	OUT
L27
	BT L21
	TST '$'
	BF L28
	LB
	GN1
	OUT
	CLL EX3
	BE
	CL 'BT '
	GN1
	OUT
	CL 'SET'
	OUT
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
	CL 'CI'
	OUT
L32
	BT L33
	SR
	BF L34
	CL 'CL '
	CI
	OUT
L34
	BT L33
	TST '#'
	BF L35
	CL 'GN'
	OUT
L35
	BT L33
	TST '.NL'
	BF L36
	CL 'NL'
	OUT
L36
	BT L33
	TST '.LB'
	BF L37
	CL 'LB'
	OUT
L37
	BT L33
	TST '.TB'
	BF L38
	CL 'TB'
	OUT
L38
	BT L33
	TST '.LM+'
	BF L39
	CL 'LMI'
	OUT
L39
	BT L33
	TST '.LM-'
	BF L40
	CL 'LMD'
	OUT
L40
L33
	R
	END
