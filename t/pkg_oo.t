use strict;
use Data::Section::Simple;

use lib "t";
use Foo;

use Test::More;

my $d = Data::Section::Simple->new('Foo');
my $x = $d->get_data_section();
is_deeply [ sort keys %$x ], [ qw(bar.tt foo.html) ];

is $d->get_data_section('foo.html'), <<HTML;
<html>
<body>Foo</body>
</html>

HTML

is $d->get_data_section('bar.tt'), <<TT;
[% IF foo %]
bar
[% END %]

TT

done_testing;

