use lib "t";
use DataInCode;
use Test::More;
use Data::Section::Simple;

my $d = Data::Section::Simple->new('DataInCode');
my $x = $d->get_data_section;

is $x->{foo}, "bar\n\n";

done_testing;



