package DataInCode;

my $code = <<EOF;
Foo
__DATA__
Bar
EOF

1;

__DATA__

@@ foo
bar

@@ bar
baz
