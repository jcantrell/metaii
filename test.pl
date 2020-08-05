my $str = "a'bcd'e'f";
#my $reg = "'[.-']*'";
my $reg = "'[^']*'";
if ($str =~ /($reg)/) {
  my $m = $1;
  print "Match was:$m:\n";
}
