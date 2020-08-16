	ADR PROGRAM
PROGRAM
	TST '.SYNTAX'
GN: labelcount: 1
	BF LL1
	ID
	BE
	LB
	TB
	CL 'ADR '
	CI
	NL
GN: labelcount: 2
LL2
	CLL PR
	BT LL2
	SET
	BE
	TST '.TOKENS'
	BE
GN: labelcount: 3
LL3
	CLL TR
	BT LL3
	SET
	BE
	TST '.END'
	BE
	TB
	CL 'END'
	NL
LL1
GN: labelcount: 4
LL4
	R
PR
	ID
GN: labelcount: 5
	BF LL5
	LB
	CI
	NL
	TST '='
	BE
	CLL EX1
	BE
	TST ';'
	BE
	TB
	CL 'R'
	NL
LL5
GN: labelcount: 6
LL6
	R
TR
	ID
GN: labelcount: 7
	BF LL7
	LB
	CI
	NL
	TST ':'
	BE
	CLL TX1
	BE
	TST ';'
	BE
	TB
	CL 'R'
	NL
LL7
GN: labelcount: 8
LL8
	R
EX1
	CLL EX2
GN: labelcount: 9
	BF LL9
GN: labelcount: 10
LL10
	TST '/'
GN: labelcount: 11
	BF LL11
	TB
	CL 'BT L'
	GN
	NL
	CLL EX2
	BE
LL11
GN: labelcount: 12
LL12
	BT LL10
	SET
	BE
	LB
	CL 'L'
	GN
	NL
LL9
GN: labelcount: 13
LL13
	R
EX2
	CLL EX3
GN: labelcount: 14
	BF LL14
	TB
	CL 'BF L'
	GN
	NL
LL14
GN: labelcount: 15
	BT LL15
	CLL OUTPUT
GN: labelcount: 16
	BF LL16
LL16
LL15
GN: labelcount: 17
	BF LL17
GN: labelcount: 18
LL18
	CLL EX3
GN: labelcount: 19
	BF LL19
	TB
	CL 'BE'
	NL
LL19
GN: labelcount: 20
	BT LL20
	CLL OUTPUT
GN: labelcount: 21
	BF LL21
LL21
LL20
	BT LL18
	SET
	BE
	LB
	CL 'L'
	GN
	NL
LL17
GN: labelcount: 22
LL22
	R
EX3
	ID
GN: labelcount: 23
	BF LL23
	TB
	CL 'CLL '
	CI
	NL
LL23
GN: labelcount: 24
	BT LL24
	SR
GN: labelcount: 25
	BF LL25
	TB
	CL 'TST '
	CI
	NL
LL25
	BT LL24
	TST '.ID'
GN: labelcount: 26
	BF LL26
	TB
	CL 'ID'
	NL
LL26
	BT LL24
	TST '.NUMBER'
GN: labelcount: 27
	BF LL27
	TB
	CL 'NUM'
	NL
LL27
	BT LL24
	TST '.STRING'
GN: labelcount: 28
	BF LL28
	TB
	CL 'SR'
	NL
LL28
	BT LL24
	TST '('
GN: labelcount: 29
	BF LL29
	CLL EX1
	BE
	TST ')'
	BE
LL29
	BT LL24
	TST '.EMPTY'
GN: labelcount: 30
	BF LL30
	TB
	CL 'SET'
	NL
LL30
	BT LL24
	TST '$'
GN: labelcount: 31
	BF LL31
	LB
	CL 'L'
	GN
	NL
	CLL EX3
	BE
	TB
	CL 'BT L'
	GN
	NL
	TB
	CL 'SET'
	NL
LL31
LL24
	R
OUTPUT
	TST '.OUT'
GN: labelcount: 32
	BF LL32
	TST '('
	BE
GN: labelcount: 33
LL33
	CLL OUT1
	BT LL33
	SET
	BE
	TST ')'
	BE
LL32
GN: labelcount: 34
LL34
	R
OUT1
	TST '*'
GN: labelcount: 35
	BF LL35
	TB
	CL 'CI'
	NL
LL35
GN: labelcount: 36
	BT LL36
	SR
GN: labelcount: 37
	BF LL37
	TB
	CL 'CL '
	CI
	NL
LL37
	BT LL36
	NUM
GN: labelcount: 38
	BF LL38
	TB
	CL 'CC '
	CI
	NL
LL38
	BT LL36
	TST '#'
GN: labelcount: 39
	BF LL39
	TB
	CL 'GN'
	NL
LL39
	BT LL36
	TST '.NL'
GN: labelcount: 40
	BF LL40
	TB
	CL 'NL'
	NL
LL40
	BT LL36
	TST '.LB'
GN: labelcount: 41
	BF LL41
	TB
	CL 'LB'
	NL
LL41
	BT LL36
	TST '.TB'
GN: labelcount: 42
	BF LL42
	TB
	CL 'TB'
	NL
LL42
	BT LL36
	TST '.LM+'
GN: labelcount: 43
	BF LL43
	TB
	CL 'LMI'
	NL
LL43
	BT LL36
	TST '.LM-'
GN: labelcount: 44
	BF LL44
	TB
	CL 'LMD'
	NL
LL44
LL36
	R
TX1
	CLL TX2
GN: labelcount: 45
	BF LL45
GN: labelcount: 46
LL46
	TST '/'
GN: labelcount: 47
	BF LL47
	TB
	CL 'BT T'
	GN
	NL
	CLL TX2
	BE
LL47
GN: labelcount: 48
LL48
	BT LL46
	SET
	BE
	LB
	CL 'T'
	GN
	NL
LL45
GN: labelcount: 49
LL49
	R
TX2
	CLL TX3
GN: labelcount: 50
	BF LL50
	TB
	CL 'BF T'
	GN
	NL
GN: labelcount: 51
LL51
	CLL TX3
GN: labelcount: 52
	BF LL52
	TB
	CL 'RF'
	NL
LL52
GN: labelcount: 53
LL53
	BT LL51
	SET
	BE
	LB
	CL 'T'
	GN
	NL
LL50
GN: labelcount: 54
LL54
	R
TX3
	TST '.TOKEN'
GN: labelcount: 55
	BF LL55
	TB
	CL 'TFT'
	NL
LL55
GN: labelcount: 56
	BT LL56
	TST '.DELTOK'
GN: labelcount: 57
	BF LL57
	TB
	CL 'TFF'
	NL
LL57
	BT LL56
	TST '$'
GN: labelcount: 58
	BF LL58
	LB
	CL 'T'
	GN
	NL
	CLL TX3
	BE
	TB
	CL 'BT T'
	GN
	NL
LL58
LL56
GN: labelcount: 59
	BF LL59
	TB
	CL 'SET'
	NL
LL59
GN: labelcount: 60
	BT LL60
	TST '.ANYBUT('
GN: labelcount: 61
	BF LL61
	CLL CX1
	BE
	TST ')'
	BE
	TB
	CL 'NOT'
	NL
	TB
	CL 'SCN'
	NL
LL61
	BT LL60
	TST '.ANY('
GN: labelcount: 62
	BF LL62
	CLL CX1
	BE
	TST ')'
	BE
	TB
	CL 'SCN'
	NL
LL62
	BT LL60
	ID
GN: labelcount: 63
	BF LL63
	TB
	CL 'CLL '
	CI
	NL
LL63
	BT LL60
	TST '('
GN: labelcount: 64
	BF LL64
	CLL TX1
	BE
	TST ')'
	BE
LL64
LL60
	R
CX1
	CLL CX2
GN: labelcount: 65
	BF LL65
GN: labelcount: 66
LL66
	TST '!'
GN: labelcount: 67
	BF LL67
	TB
	CL 'BT C'
	GN
	NL
	CLL CX2
	BE
LL67
GN: labelcount: 68
LL68
	BT LL66
	SET
	BE
	LB
	CL 'C'
	GN
	NL
LL65
GN: labelcount: 69
LL69
	R
CX2
	CLL CX3
GN: labelcount: 70
	BF LL70
	TST ':'
GN: labelcount: 71
	BF LL71
	TB
	CL 'CGE '
	CI
	NL
	TB
	CL 'BF D'
	GN
	NL
	CLL CX3
	BE
	TB
	CL 'CLE '
	CI
	NL
	LB
	CL 'D'
	GN
	NL
LL71
GN: labelcount: 72
	BT LL72
	SET
GN: labelcount: 73
	BF LL73
	TB
	CL 'CE '
	CI
	NL
LL73
LL72
	BE
LL70
GN: labelcount: 74
LL74
	R
CX3
	NUM
GN: labelcount: 75
	BF LL75
LL75
GN: labelcount: 76
LL76
	R
	END
