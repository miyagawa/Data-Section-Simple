package Data::Section::Simple;

use strict;
use 5.008_001;
our $VERSION = '0.05';

use base qw(Exporter);
our @EXPORT_OK = qw(get_data_section);

sub new {
    my($class, $pkg) = @_;
    bless { package => $pkg || caller }, $class;
}

sub get_data_section {
    my $self = ref $_[0] ? shift : __PACKAGE__->new(scalar caller);

    if (@_) {
        my $all = $self->get_data_section;
        return unless $all;
        return $all->{$_[0]};
    } else {
        my $d = do { no strict 'refs'; \*{$self->{package}."::DATA"} };
        return unless defined fileno $d;

        seek $d, 0, 0;
        my $content = join '', <$d>;
        $content =~ s/^.*\n__DATA__\n/\n/s; # for win32
        $content =~ s/\n__END__\n.*$/\n/s;

        my @data = split /^@@\s+(.+?)\s*\r?\n/m, $content;
        shift @data; # trailing whitespaces

        my $all = {};
        while (@data) {
            my ($name, $content) = splice @data, 0, 2;
            $all->{$name} = $content;
        }

        return $all;
    }
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Data::Section::Simple - Read data from __DATA__

=head1 SYNOPSIS

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

=head1 DESCRIPTION

Data::Section::Simple is a simple module to extract data from
C<__DATA__> section of the file.

=head1 LIMITATIONS

As the name suggests, this module is a simpler version of the
excellent L<Data::Section>. If you want more functionalities such as
merging data sections or changing header patterns, use
L<Data::Section> instead.

This module does not implement caching (yet) which means in every
C<get_data_section> or C<< get_data_section($name) >> this module
seeks and re-reads the data section. If you want to avoid doing so for
the better performance, you should implement caching in your own
caller code.

=head1 BUGS

=head2 __DATA__ appearing elsewhere

If you data section has literal C<__DATA__> in the data section, this
module might be tricked by that. Although since its pattern match is
greedy, C<__DATA__> appearing I<before> the actual data section
(i.e. in the code) might be okay.

This is by design -- in theory you can C<tell> the DATA handle before
reading it, but then reloading the data section of the file (handy for
developing inline templates with PSGI web applications) would fail
because the pos would be changed.

If you don't like this design, again, use the superior
L<Data::Section>.

=head2 utf8 pragma

If you enable L<utf8> pragma in the caller's package (or the package
you're inspecting with the OO interface), the data retrieved via
C<get_data_section> is decoded, but otherwise undecoded. There's no
reliable way for this module to programmatically know whether utf8
pragma is enabled or not: it's your responsibility to handle them
correctly.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

=head1 COPYRIGHT

Copyright 2010- Tatsuhiko Miyagawa

The code to read DATA section is based on Mojo::Command get_all_data:
Copyright 2008-2010 Sebastian Riedel

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Data::Section> L<Inline::Files>

=cut
