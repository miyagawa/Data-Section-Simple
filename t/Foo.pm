package Foo;

1;

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

Foo

=cut
