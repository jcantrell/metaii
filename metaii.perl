#!/usr/bin/perl
use warnings;
use strict;
use List::Util qw[min];

# Globals, mostly for IO
# META II VM machine code for META II language
my $text = q(
	ADR PROGRAM
OUT1
	TST '*1'
	BF L1
	CL 'GN1'
	OUT
L1
	BT L2
	TST '*2'
	BF L3
	CL 'GN2'
	OUT
L3
	BT L2
	TST '*'
	BF L4
	CL 'CI'
	OUT
L4
	BT L2
	SR
	BF L5
	CL 'CL '
	CI
	OUT
L5
L2
	R
OUTPUT
	TST '.OUT'
	BF L6
	TST '('
	BE
L7
	CLL OUT1
	BT L7
	SET
	BE
	TST ')'
	BE
L6
	BT L8
	TST '.LABEL'
	BF L9
	CL 'LB'
	OUT
	CLL OUT1
	BE
L9
L8
	BF L10
	CL 'OUT'
	OUT
L10
L11
	R
EX3
	ID
	BF L12
	CL 'CLL '
	CI
	OUT
L12
	BT L13
	SR
	BF L14
	CL 'TST '
	CI
	OUT
L14
	BT L13
	TST '.ID'
	BF L15
	CL 'ID'
	OUT
L15
	BT L13
	TST '.NUMBER'
	BF L16
	CL 'NUM'
	OUT
L16
	BT L13
	TST '.STRING'
	BF L17
	CL 'SR'
	OUT
L17
	BT L13
	TST '('
	BF L18
	CLL EX1
	BE
	TST ')'
	BE
L18
	BT L13
	TST '.EMPTY'
	BF L19
	CL 'SET'
	OUT
L19
	BT L13
	TST '$'
	BF L20
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
L20
L13
	R
EX2
	CLL EX3
	BF L21
	CL 'BF '
	GN1
	OUT
L21
	BT L22
	CLL OUTPUT
	BF L23
L23
L22
	BF L24
L25
	CLL EX3
	BF L26
	CL 'BE'
	OUT
L26
	BT L27
	CLL OUTPUT
	BF L28
L28
L27
	BT L25
	SET
	BE
	LB
	GN1
	OUT
L24
L29
	R
EX1
	CLL EX2
	BF L30
L31
	TST '/'
	BF L32
	CL 'BT '
	GN1
	OUT
	CLL EX2
	BE
L32
L33
	BT L31
	SET
	BE
	LB
	GN1
	OUT
L30
L34
	R
ST
	ID
	BF L35
	LB
	CI
	OUT
	TST '='
	BE
	CLL EX1
	BE
	TST '.,'
	BE
	CL 'R'
	OUT
L35
L36
	R
PROGRAM
	TST '.SYNTAX'
	BF L37
	ID
	BE
	CL 'ADR '
	CI
	OUT
L38
	CLL ST
	BT L38
	SET
	BE
	TST '.END'
	BE
	CL 'END'
	OUT
L37
L39
	R
	END
);
# End VM code
# Begin IO globals
if ($#ARGV+1 == 0)
{ 
  print "Usage: metaii codefile vmassembly\n"; 
  exit 1;
}
my $df = $ARGV[0];
my $tf = \$text;
if (scalar @ARGV > 1)
  { $tf = $ARGV[1]; }
my $TF;
open($TF, '<', $tf) or die "Can't find $tf\n$!";
open(DF, '<', $df) or die "Can't find $df\n$!";
# End IO globals

# VM global constructs
# VM consists of Instruction set, a boolean switch,
# data stack, input text, output buffer,
# label table, token buffer
# Rom array, instruction set, label table
my $switch = 0;
my $token_buffer = "";
my $output_buffer = "\t";
my $run = 1;
my @rom;
my %opcodes = 
(
  'TST', \&TST, 
  'ID', \&ID,
  'NUM', \&NUM,
  'SR', \&SR,
  'CLL', \&CLL,
  'R', \&R,
  'SET', \&SET,
  'B', \&B,
  'BT', \&BT,
  'BF', \&BF,
  'BE', \&BE,
  'CL', \&CL,
  'CI', \&CI,
  'GN1', \&GN1,
  'GN2', \&GN2,
  'LB', \&LB,
  'OUT', \&OUT,

  'ADR', \&ADR,
  'END', \&opcodeEND,

  'GN', \&GN,
  'NL', \&NL,
  'TB', \&TB,
  'LMI', \&LMI,
  'LMD', \&LMD,

  'CC', \&CC,
  'RF', \&RF,
  'TFT', \&TFT,
  'TFF', \&TFF,
  'NOT', \&NOT,
  'SCN', \&SCN,
  'CGE', \&CGE,
  'CLE', \&CLE,
  'CE', \&CE,
  'LCH', \&LCH,
);
my %labels;
my $startlabel = "";
my $labelcount = 1;
my $pc = 0;
my @stack;

# Extension constructs
my $margin_counter = 0;
# Step 10 extension stuff
my $token_flag = 0;
# Debug stuff
my $debug_flag = 0;
my $debug_dump = 0;
my %errors =
(
  "LABEL_NOT_FOUND" => "Label or rule not found",
  "OPCODE_NOT_FOUND" => "Encountered nonexistent opcode",
  "INFINITE_RECURSION" => "Infinite recursion",
  "DATAFILE_NOT_FOUND" => "Data file not found",
  "EMPTY_CODE_FILE" => "Code file is empty",
  "INVALID_PC_VALUE" => "PC register was invalid",
  "UNEXPECTED_FILE_END" => "File ended unexpectedly",
  "RUNTIME_ERROR" => "Unknown error"
);
my $error_buffer = "";
my $oss = "";
my %debug_call_table;
my $recursion_detection = 0;

# Helper methods
# Skip over string in DF
sub file_skip {
	my $prefix = $_[0];
  my $buffer = "";
  my $maxbufferlength = 1000;
  my $count = read(DF, $buffer, $maxbufferlength);
  my $res = "";

  my $l = min( length($buffer) , length($prefix) );
	while ($prefix ne "" 
        and substr($buffer,0,$l) eq substr($prefix,0,$l))
  {
    $res .= substr($buffer,0,$l);
    $buffer = substr($buffer,$l);
    $prefix = substr($prefix,$l);
    $l = min( length($buffer) , length($prefix) );
		$count += read(DF, $buffer, $maxbufferlength);
  }

  #seek(DF,-$count,SEEK_CUR);
  seek(DF,-$count+length($res),1);
  return $res;
}

# Skip over regex match in DF
# TODO: What if match spans string larger than buffer?
sub file_skip_regex {
	my $regex = $_[0];
  my $buffer = "";
  my $maxbufferlength = 1000;
  my $count = read(DF, $buffer, $maxbufferlength);
  if ($count == 0) { 
    # interpreter_error("UNEXPECTED_FILE_END", $df);
    # exit 1;
    exit;
  }
  my $res = "";
  $res = $1 if $buffer =~ /($regex)/;
  seek(DF,-$count+length($res),1);
  #print STDERR "skip_regex res:$res pos:".tell(DF)."\n";
  dbe("skip_regex res:$res pos:".tell(DF)."\n");
  return $res;
}

sub file_peek_regex {
  my $r = file_skip_regex($_[0]);
  seek(DF, -length($r), 1);
  return $r;
}

sub file_peek_char {
  my $r = '';
  my $count = read(DF, $r, 1);
  seek(DF, -length($r), 1);
  return $r;
}

sub file_skip_char {
  my $r = '';
  my $count = read(DF, $r, 1);
  #seek(DF, -length($r), 1);
  return $r;
}

# META II opcodes
sub TST {
  file_skip_regex("^\\s*");
	my $prefix = $_[0];
  $prefix =~ s/^'|'$//g;
  $switch = (file_skip($prefix) eq $prefix);
}

sub ID {
  file_skip_regex("^\\s*");
  my $regex = "^[a-zA-Z]+[a-zA-Z0-9]*";
  $switch = (($token_buffer = file_skip_regex($regex)) ne "");
}

sub NUM {
  file_skip_regex("^\\s*");
  my $regex = "^[0-9]+";
  $switch = (($token_buffer = file_skip_regex($regex)) ne "");
}

sub SR {
  file_skip_regex("^\\s*");
  my $regex = "^'[^']*'";
  $switch = (($token_buffer = file_skip_regex($regex)) ne "");
}

sub CLL {
  push(@stack,"");
  push(@stack,"");
  push(@stack,$pc);

  #if ($debug_flag)
  #  { print(STDERR "CLL: $_[0]\n"); }
  dbe("CLL: $_[0]\n");

  if (!exists($labels{$_[0]}))
    { interpreter_error("LABEL_NOT_FOUND", $_[0]); }

  if ($recursion_detection) {
  my $ss = join(",",@stack[ map { 2 + 3 * $_ } 0..$#stack/3]).",".$_[0];
  my $pl = 0;
  while ($pl < length($oss) && $pl < length($ss) && substr($oss,$pl,1) eq substr($ss,$pl,1))
    { $pl++; }
  my $diff = substr($ss,$pl,length($ss)-$pl);
  $oss = $ss;

#  if ($debug_flag) {
#    print STDERR "call table for $diff is ".tell(DF)."\n";
#    if (exists($debug_call_table{$diff})) {
#      print STDERR " table value: ".$debug_call_table{$diff}."\n";
#    }
#  }
  dbe("call table for $diff is ".tell(DF)."\n");
  if (exists($debug_call_table{$diff})) {
    dbe(" table value: ".$debug_call_table{$diff}."\n");
  }

  if (exists($debug_call_table{$diff}) and ($debug_call_table{$diff} == tell(DF)))
    { interpreter_error("INFINITE_RECURSION", $diff); }
  $debug_call_table{$diff} = tell(DF);
  }
  
  # -1 to account for auto-increment after each instruction
  $pc = $labels{$_[0]}-1; 
}

sub R {
  if (scalar(@stack) == 0) { opcodeEND(); }
  $pc = (pop @stack);
  pop @stack;
  pop @stack;
}

sub SET {
  $switch = 1;
}

sub B {
  $pc = $labels{$_[0]}-1; 
}

sub BT {
  if ($switch)
    { $pc = $labels{$_[0]}-1; }
}

sub BF {
  if (!$switch)
    { $pc = $labels{$_[0]}-1; }
}

sub BE {
  if ($switch) { return; }
  $run = 0;
  interpreter_error("RUNTIME_ERROR", "Position: ".tell(DF));
}

sub CL {
	my $s = $_[0];
  $s =~ s/^'|'$//g;
  $output_buffer .= $s;
}

sub CI {
  $output_buffer .= $token_buffer;
}

sub GN1 {
  if ($stack[$#stack-2] eq "") {
    $stack[$#stack-2] = "L".$labelcount;
    $labelcount++;
  }
  $output_buffer .= $stack[$#stack-2];
}

sub GN2 {
  if ($stack[$#stack-1] eq "") {
    $stack[$#stack-1] = "L".$labelcount;
    $labelcount++;
  }
  $output_buffer .= $stack[$#stack-1];
}

sub LB {
  $output_buffer = "";
}

sub OUT {
  print "$output_buffer\n";
  $output_buffer = "\t";
}

# META II pseudo-operations
sub ADR {
  $startlabel = $_[0];
}

sub opcodeEND {
  $run = 0;
}

# Extension opcodes - Margins
sub GN {
  if ($stack[$#stack-2] eq "") {
    $stack[$#stack-2] = $labelcount;
    $labelcount++;
  }
  $output_buffer .= $stack[$#stack-2];
}

sub NL {
  print "$output_buffer\n";
  $output_buffer = ' ' x $margin_counter;
}

sub TB {
  $output_buffer .= "\t";
}

sub LMI {
  $margin_counter++;
}

sub LMD {
  $margin_counter--;
}

# Token and character extensions
sub CC {
  $output_buffer .= chr($_[0]);
}

sub RF {
  if (!$switch) { R(); }
}

sub TFT {
  $token_flag = 1;
  $token_buffer = "";
}

sub TFF {
  $token_flag = 0;
}

sub NOT {
  $switch = !$switch;
}

sub SCN {
  if (!$switch) { return; }
  #print STDERR "SCN p:$switch: :$token_flag: ".tell(DF)."\n";
  dbe("SCN p:$switch: :$token_flag: ".tell(DF)."\n");
  #my $c = file_skip_regex(".");
  my $c = file_skip_char();
  dbe("SCN :$switch: :$token_flag: $c ".tell(DF)."\n");
  if ($token_flag) { $token_buffer .= $c; }
}

sub CGE {
  dbe("CGE :$_[0]: ".$_[0]." peek:".file_peek_char()."\n");
  #$switch = (ord(file_peek_regex(".")) >= $_[0]);
  $switch = (ord(file_peek_char()) >= $_[0]);
}

sub CLE {
  dbe("CLE $_[0] '".ord($_[0])."'\n");
  $switch = (ord(file_peek_char()) <= $_[0]);
}

sub CE {
  dbe("CE $_[0] '".ord($_[0])."'\n");
  $switch = (ord(file_peek_char()) == $_[0]);
}

sub LCH {
  $token_buffer = "".ord(file_skip_char());
}

# VM interpreter
sub interpreter_state_dump {
  print STDERR "Interpreter dump:\n\n";
  print STDERR "Switch: $switch\n\n";
  print STDERR "Token buffer: $token_buffer\n\n";
  print STDERR "Output buffer: $output_buffer\n\n";
  print STDERR "Run: $run\n\n";
  print STDERR "Rom:\n";
  foreach my $cell(@rom) { 
    print STDERR "$cell->[0] ";
    if (defined $cell->[1]) {
      print STDERR "$cell->[1]\n"; 
    }
  }
  print "\n";
  print STDERR "Opcodes:\n";
  foreach my $key (keys %opcodes) { 
    print STDERR "$key $opcodes{$key}\n"; 
  }
  print "\n";
  print STDERR "Labels:\n";
  foreach my $key (keys %labels) { 
    print STDERR "$key $labels{$key}\n"; 
  }
  print "\n";
  print STDERR "Start label: $startlabel\n";
  print STDERR "Label count: $labelcount\n";
  print STDERR "PC: $pc\n";
  print STDERR "Stack:\n";
  my @ss = @stack[ map { 2 + 3 * $_ } 0..$#stack/3];
  foreach (@ss) { print STDERR "$_\n"; }
}

sub dbe {
  if ($debug_flag) { print STDERR $_[0]; }
}

sub interpreter_error {
  print STDERR "Interpreter error:\n";
  $run = 0;
  print STDERR $errors{$_[0]}."\n";
  print STDERR $_[1]."\n";
  if ($debug_flag and $debug_dump) {
    interpreter_state_dump();
  }
  exit 1;
}

sub interpret {
  # Read code text into VM ROM
  my $address = 0;
  if (-z $TF) { 
    interpreter_error("EMPTY_CODE_FILE", $tf);
  }
  while (<$TF>) {
    my $line = $_;
    chomp($line);
    if (!($line=~ /^(\s*)(\S+)(\s+)?(\S|(\S.*\S))?(\s*)$/))
      { next; }
    if ($1 eq "") {
      if (substr($2, 0, 1) ne ";") {
        $labels{$2} = $address;
      }
    } elsif ($2 eq "ADR") {
      $opcodes{$2}->($4);
    } else {
      if (!exists($opcodes{$2}))
      { interpreter_error("OPCODE_NOT_FOUND", $2); }
      push(@rom, [$2, $4]);
      $address++;
    }
  }

  $pc = $labels{$startlabel};
  while ($run) {
    if ($pc >= scalar @rom) 
      { interpreter_error("INVALID_PC_VALUE", $pc); }
    $opcodes{$rom[$pc][0]}->($rom[$pc][1]);
    $pc++;
  }
}

interpret();

close(DF);
