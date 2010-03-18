use strict;
use Data::Section::Simple qw(get_data_section);
use Test::More;

my $x = get_data_section();
is_deeply [ sort keys %$x ], [ qw(bar.tt foo.html) ];

is get_data_section('foo.html'), <<HTML;
<html>
<body>Foo</body>
</html>

HTML

is get_data_section('bar.tt'), <<TT;
[% IF foo %]
bar
[% END %]

TT

done_testing;

__DATA__

@@ foo.html
<html>
<body>Foo</body>
</html>

@@ bar.tt  
[% IF foo %]
bar
[% END %]

__END__

=head1 NAME

basic.t

=cut
