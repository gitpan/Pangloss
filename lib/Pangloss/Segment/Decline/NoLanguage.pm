=head1 NAME

Pangloss::Segment::Decline::NoLanguage - decline unless there's a language in the store

=head1 SYNOPSIS

  $pipe->add_segment( Pangloss::Segment::NoLanguage->new )

=cut

package Pangloss::Segment::Decline::NoLanguage;

use base qw( OpenFrame::WebApp::Segment::Decline );

our $VERSION  = ((require Pangloss::Version), $Pangloss::VERSION)[1];
our $REVISION = (split(/ /, ' $Revision: 1.2 $ '))[2];

sub should_decline {
    my $self = shift;
    $self->store->get('Pangloss::Language') ? 0 : 1;
}

1;

__END__

#------------------------------------------------------------------------------

=head1 DESCRIPTION

Inherits from C<OpenFrame::WebApp::Segment::Decline>.

=head1 AUTHOR

Steve Purkis <spurkis@quiup.com>

=head1 SEE ALSO

L<Pangloss::Language>

=cut
