=head1 NAME

Pangloss::accessors - create accessors in Pangloss objects.

=head1 SYNOPSIS

  use Pangloss::accessors;

  package Foo;
  use accessors qw( foo bar baz );

  sub my_method {
      my $self = shift;
      $self->foo( shift )
           ->bar( shift );
      print $self->foo, $self->bar, if $self->baz;
  }

=cut

package accessors;

our $Loaded = 0;

BEGIN { return 1 if $Loaded };

use strict;
use warnings::register;

our $Debug       = 0;
our $ExportLevel = 0;

sub import {
    my $class   = shift;
    my $callpkg = caller($ExportLevel);

    warn "creating accessors( ", join(' ', @_), " ) in pkg '$callpkg'" if $Debug;
    create_cascading_accessor_for( $callpkg, $_ ) for (@_);

    return $class;
}

sub create_cascading_accessor_for {
    my $callpkg  = shift;
    my $property = shift;

    warn( "creating accessor: $callpkg\::$property\n" ) if $Debug > 1;
    # seems to be faster if we eval instead of setting anonymous subs...
    eval "sub $callpkg\::$property {
	if (\@_ > 1) { \$_[0]->{-$property} = \$_[1]; return \$_[0]; }
	else         { return \$_[0]->{-$property}; }
    }";
}

#------------------------------------------------------------------------------
# This make it look like the 'accessors' pragma actually exists, without
# invading the core perl namespace ...

BEGIN {
    warn "faking accessors.pm in \%INC" if warnings::enabled();
    $INC{'accessors.pm'} = $INC{'Pangloss/accessors.pm'};
}

$Loaded = 1;

__END__

=head1 DESCRIPTION

Create accessors in a class's namespace of the style:

  sub $property {
      my $self = shift;
      if (@_) { $self->{"-$property"} = shift; return $self; }
      else    { return $self->{"-$property"}; }
  }

So that you don't have to write the above 1000 times.  Written in such a way
that you can cascade your sets:

  my $foo = Foo->new->bar(1)->baz(2);

Which can be quite useful.

=head1 NOTES

Installed as the 'accessor' pragma, but the module lives under the Pangloss
namespace so we avoid invading the perl core.

=head1 THANKS

Inspired from code by Michael G. Schwern.

=head1 AUTHOR

Steve Purkis <spurkis@quiup.com>

=head1 SEE ALSO

L<Pangloss::Object>, L<Pangloss::Error>

L<Class::Accessor>

=cut
