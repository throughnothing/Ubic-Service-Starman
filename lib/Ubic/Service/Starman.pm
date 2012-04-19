use strict;
use warnings;
package Ubic::Service::Starman;

# Set the plackup bin to starman
sub BEGIN { $ENV{'UBIC_SERVICE_PLACKUP_BIN'} = 'starman'; }

use base qw(Ubic::Service::Plack);

use Ubic::Daemon::PidState;
use Params::Validate qw(:all);

# ABSTRACT: Helper for running psgi applications with Starman

sub new {
    my ($class, %args ) = @_;

    $args{server} = 'Starman';
    return $class->SUPER::new( %args );
}

sub reload {
    my ( $self ) = @_;

    my $pid_data = Ubic::Daemon::PidState->new($self->pidfile)->read;
    kill HUP => $pid_data->{daemon};
    return 'reloaded';
}

=head1 NAME

Ubic::Service::Starman - ubic service base class for psgi applications

=head1 SYNOPSIS

    use Ubic::Service::Starman;
    return Ubic::Service::Starman->new({
        server_args => {
            listen => "/tmp/app.sock",
        },
        app => "/var/www/app.psgi",
        status => sub { ... },
        port => 4444,
        ubic_log => '/var/log/app/ubic.log',
        stdout => '/var/log/app/stdout.log',
        stderr => '/var/log/app/stderr.log',
        user => "www-data",
    });

=head1 DESCRIPTION

This service is a common ubic wrap for psgi applications.
It uses starman for running these applications.

It is a very simple wrapper around L<Ubic::Service::Plack> that
uses L<starman> as the binary instead of L<plackup>.  It
defaults the C<server> argument to 'Starman' so you don't have to pass
it in, and adds the ability to reload (which will gracefully restart
your L<Starman> workers without any connections lost) using
C<ubic reload service_name>.

=head1 METHODS

=over

=item reload

Reload adds the ability to send a C<HUP> signal to the L<Starman> server
to gracefully reload your app and all the workers without losing any
connections.

=back

=cut


1;
