#!/usr/bin/perl
use warnings;
use strict;
use List::Util qw[min];

my $f = 'testfile.txt';
my $buffer = "";
my $maxbufferlength = 1000;
open(FH, '<', $f) or die $!;
read(FH, $buffer, $maxbufferlength);

# VM consists of Instruction set, a boolean switch,
# callstack, data stack, input text, output buffer,
# label table, token buffer
my $switch;

sub file_skip_whitespace() {
	my $b = "";
	my $ws = 1;
  my $c = 0;
	while ($ws) {
		$c = read(FH, $b, 1);
		$ws = ($b =~ /\s/);
	}
  if ($c>0) { seek(FH,-$c,1); }
}

# Does FH begin with the given string?
sub file_test {
	my $prefix = $_[0];
  my $count = 0;
  my $l = min( length($buffer) , length($prefix) );
	while ($prefix ne "" and substr($buffer,0,$l) eq substr($prefix,0,$l))
  {
    $buffer = substr($buffer,$l);
    $prefix = substr($prefix,$l);
    $l = min( length($buffer) , length($prefix) );
		$count += read(FH, $buffer, $maxbufferlength);
  }
  #seek(FH,-$count,SEEK_CUR);
  seek(FH,-$count,1);
  return ($prefix eq "");
}

# META II opcodes
sub TST {
  file_skip_whitespace();
  if (file_test($_[0])) {
    file_skip($_[0]);
    $switch = 1;
  } else {
    $switch = 0;
  }
}

sub ID {
  file_skip_whitespace();
  my $regex = "[a-zA-Z]+[a-zA-Z0-9]*";
  if (file_test_regex($regex)) {
    $token_buffer = file_skip_regex($regex);
    $switch = 1;
  } else {
    $switch = 0;
  }
}

sub NUM {
  file_skip_whitespace();
  $regex = "[0-9]+";
  if (file_test_regex($regex)) {
    $token_buffer = file_skip_regex($regex);
    $switch = 1;
  } else {
    $switch = 0;
  }
}

sub SR {
  file_skip_whitespace();
  $regex = "'[^']*'";
  if (file_test_regex($regex)) {
    $token_buffer = file_skip_regex($regex);
    $switch = 1;
  } else {
    $switch = 0;
  }
}

sub CLL {
  #TODO: Implement VM interpreter, this needs the vm runtime
}

sub R {
  #TODO: Implement VM interpreter, this needs the vm runtime
}

sub SET {
  $switch = 1;
}

sub B {
}

sub BT {
}

sub BF {
}

sub BE {
}

sub CL {
  print $_[0];
}

sub CI {
  print $token_buffer;
}


close(FH);
