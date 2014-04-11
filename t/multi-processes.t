use strict;
use Data::Section::Simple qw(get_data_section);
use Test::More;

my $expect =<<HTML;
<html>
<body>Foo</body>
</html>

HTML

my $n = 100;
while ($n-- > 0) {
    fork && next;
    exit(get_data_section('foo.html') eq $expect ? 0 : 1);
}

my $failed = 0;
while (waitpid(-1,0) > 0) {
    $failed = 1 if $? >> 8 != 0;
}

ok(!$failed);

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
