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
my $df = 'datafile';
my $tf = \$text;
my $TF;
open($TF, '<', $tf) or die $!;
open(DF, '<', $df) or die $!;
# End IO globals

# Begin area for quick and dirty test code
#print "TF:\n";
#while (<$TF>) {
#  print;
#}
# End test code area

# VM global constructs
# VM consists of Instruction set, a boolean switch,
# callstack, data stack, input text, output buffer,
# label table, token buffer
# Rom array, instruction set, label table
my $switch;
my $token_buffer = "";
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
);
my %labels;
my $startlabel;
my $pc;
my @stack;
my $output_buffer = "\t";
my $labelcount = 1;

# Helper methods
sub file_skip_whitespace() {
	my $b = "";
	my $ws = 1;
  my $c = 0;
	while ($ws) {
		$c = read(DF, $b, 1);
		$ws = ($b =~ /\s/);
	}
  if ($c>0) { seek(DF,-$c,1); }
}

# Skip over string in DF
sub file_skip {
	my $prefix = $_[0];
  my $debug = $prefix;
  my $buffer = "";
  my $maxbufferlength = 1000;
  my $count = 0;
  my $matched = 0;
  $count += read(DF, $buffer, $maxbufferlength);
  my $l = min( length($buffer) , length($prefix) );
  $matched += $l;
	while ($prefix ne "" 
        and substr($buffer,0,$l) eq substr($prefix,0,$l))
  {
    $buffer = substr($buffer,$l);
    $prefix = substr($prefix,$l);
    $l = min( length($buffer) , length($prefix) );
    $matched += $l;
		$count += read(DF, $buffer, $maxbufferlength);
  }
  #seek(DF,-$count,SEEK_CUR);

  #print "  SKIPPED:".substr($debug,0,$matched)."\n";

  seek(DF,-$count+$matched,1);
  return ($prefix eq "");
}

# Does DF begin with the given string?
sub file_test {
	my $prefix = $_[0];
  my $buffer = "";
  my $maxbufferlength = 1000;
  my $count = 0;
  $count += read(DF, $buffer, $maxbufferlength);
  my $l = min( length($buffer) , length($prefix) );
	while ($prefix ne "" 
        and substr($buffer,0,$l) eq substr($prefix,0,$l))
  {
    $buffer = substr($buffer,$l);
    $prefix = substr($prefix,$l);
    $l = min( length($buffer) , length($prefix) );
		$count += read(DF, $buffer, $maxbufferlength);
  }
  #seek(DF,-$count,SEEK_CUR);
  seek(DF,-$count,1);
  return ($prefix eq "");
}

# Does DF begin with the given regex?
# TODO: What if match spans string larger than buffer?
sub file_test_regex {
	my $regex = $_[0];
  my $buffer = "";
  my $maxbufferlength = 1000;
  my $count = read(DF, $buffer, $maxbufferlength);
  if ($count == 0) { exit; }
  #print "  file_test_regex buffer:".substr($buffer,0,10).":\n";
  #print "  file_test_regex  regex:$regex:\n";
  my $res = ($buffer =~ /$regex/);
  #print "  file_test_regex res:$res:\n";
  #seek(DF,-$count,SEEK_CUR);
  seek(DF,-$count,1);
  return $res;
}

# Skip over regex match in DF
# TODO: What if match spans string larger than buffer?
sub file_skip_regex {
	my $regex = $_[0];
  my $buffer = "";
  my $maxbufferlength = 1000;
  my $count = read(DF, $buffer, $maxbufferlength);
  if ($count == 0) { exit; }
  my $res = "";
  if ($buffer =~ /($regex)/) {
    $res = $1;
    #print "Regex: $regex\n";
    #print "Match: $res:".length($res)."\n";
  }
  #seek(DF,-$count,SEEK_CUR);
  seek(DF,-$count+length($res),1);
  #print "  SKIPPED:$res\n";

#  my $debug = read(DF, $buffer, 20);
#  print "File is now:$buffer:\n";
#  seek(DF,-$debug,1);

  return ($res);
}

# META II opcodes
sub TST {
  file_skip_whitespace();
	my $prefix = $_[0];
  $prefix =~ s/^'|'$//g;
  $switch = file_test($prefix);
  #print "  TST on $prefix\n";
  #if ($switch) { print "  TST succeeded\n"; }
  #else { print "  TST failed\n"; }
  if ($switch) { file_skip($prefix); }
  #print "switch is ".$switch."\n";
}

sub ID {
  file_skip_whitespace();
  my $regex = "^[a-zA-Z]+[a-zA-Z0-9]*";

  my $buffer = "";
  my $debug = read(DF, $buffer, 20);
  #print "  File is now:$buffer:\n";
  #print "  Regex is now:$regex:\n";
  seek(DF,-$debug,1);

  $switch = file_test_regex($regex);
  #print "ID switch is:".$switch."\n";
  if ($switch) { $token_buffer = file_skip_regex($regex); }
}

sub NUM {
  file_skip_whitespace();
  my $regex = "^[0-9]+";
  $switch = file_test_regex($regex);
  if ($switch) { $token_buffer = file_skip_regex($regex); }
}

sub SR {
  file_skip_whitespace();
  my $regex = "^'[^']*'";
  $switch = file_test_regex($regex);
  if ($switch) { $token_buffer = file_skip_regex($regex); }
}

sub CLL {
  push(@stack,"");
  push(@stack,"");
  push(@stack,$pc);
  # -1 to account for auto-increment after each
  # instruction
  $pc = $labels{$_[0]}-1; 
}

sub R {
  #print "R stackdump: ";
  #foreach(@stack) { print "$_ "; }
  if (scalar(@stack) == 0) { opcodeEND(); }
  $pc = (pop @stack);
  #$pc--;
  #print "Returning to ".($pc+1)."\n";
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
  print "Syntax error!\n";
  $run = 0;
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
  $output_buffer = "";
  $output_buffer = "\t"; # 8 spaces
}

# META II pseudo-operations
sub ADR {
  #print "ADR called!\n";
}

sub opcodeEND {
  $run = 0;
}


# VM interpreter
sub interpret {
  # Read code text into VM ROM
  my $address = 0;
  while (<$TF>) {
    my $line = $_;
    chomp($line);
    if ($line =~ /^(\s*)(\S+)(\s+)?(\S|(\S.*\S))?(\s*)$/) {
      my $opcode = "";
      my $arg = "";
      my $label = "";

      if (defined $4) { $arg = $4; }
      $opcode = $2;
      if ($1 eq "") 
        { ($opcode, $label) = ($label, $opcode); }

      if ($opcode ne "") {
        # Special case, catch ADR so we know
        # where to start the interpreter
        if ($opcode eq "ADR") {
          $startlabel = $arg;
        }
        push(@rom, [$opcode, $arg]);
        $address++;
      } else {
        $labels{$label} = $address;
      }
    }
  }
#  print "Rom:\n";
#  for (my $i=0; $i<scalar(@rom);$i++) {
#    #.join(", ", @rom)."\n";
#    print "\t$i: ".$rom[$i][0]." ".$rom[$i][1]."\n";
#  }
#  print "Labels:\n";
#  print "\t$_ $labels{$_}\n" for (keys %labels);
#  print "Start: $startlabel\n";
#  print "Start Address: ".$labels{$startlabel}."\n";

  
  $pc = $labels{$startlabel};
  while ($run) {
    #print "Calling: pc: $pc ".$rom[$pc][0]." with :".$rom[$pc][1].":\n";
    $opcodes{$rom[$pc][0]}->($rom[$pc][1]);
    $pc++;
  }
}

interpret();

close(DF);
