# NAME

Data::Section::Simple - Read data from \_\_DATA\_\_

# SYNOPSIS

    use Data::Section::Simple qw(get_data_section);

    # Functional interface -- reads from caller package __DATA__
    my $all = get_data_section; # All data in hash reference
    my $foo = get_data_section('foo.html');

    # OO - allows reading from other packages
    my $reader = Data::Section::Simple->new($package);
    my $all = $reader->get_data_section;

    __DATA__

    @@ foo.html
    <html>
     <body>Hello</body>
    </html>

    @@ bar.tt
    [% IF true %]
      Foo
    [% END %]

# DESCRIPTION

Data::Section::Simple is a simple module to extract data from
`__DATA__` section of the file.

# LIMITATIONS

As the name suggests, this module is a simpler version of the
excellent [Data::Section](https://metacpan.org/pod/Data::Section). If you want more functionalities such as
merging data sections or changing header patterns, use
[Data::Section](https://metacpan.org/pod/Data::Section) instead.

This module does not implement caching (yet) which means in every
`get_data_section` or `get_data_section($name)` this module
seeks and re-reads the data section. If you want to avoid doing so for
the better performance, you should implement caching in your own
caller code.

# BUGS

## \_\_DATA\_\_ appearing elsewhere

If you data section has literal `__DATA__` in the data section, this
module might be tricked by that. Although since its pattern match is
greedy, `__DATA__` appearing _before_ the actual data section
(i.e. in the code) might be okay.

This is by design -- in theory you can `tell` the DATA handle before
reading it, but then reloading the data section of the file (handy for
developing inline templates with PSGI web applications) would fail
because the pos would be changed.

If you don't like this design, again, use the superior
[Data::Section](https://metacpan.org/pod/Data::Section).

## utf8 pragma

If you enable [utf8](https://metacpan.org/pod/utf8) pragma in the caller's package (or the package
you're inspecting with the OO interface), the data retrieved via
`get_data_section` is decoded, but otherwise undecoded. There's no
reliable way for this module to programmatically know whether utf8
pragma is enabled or not: it's your responsibility to handle them
correctly.

# AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

# COPYRIGHT

Copyright 2010- Tatsuhiko Miyagawa

The code to read DATA section is based on Mojo::Loader data:
Copyright 2008-2010 Sebastian Riedel

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Data::Section](https://metacpan.org/pod/Data::Section) [Inline::Files](https://metacpan.org/pod/Inline::Files)
