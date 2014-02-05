package CPAN::ReleaseHistory::Release;

use Moo;
use CPAN::DistnameInfo;

has 'path'      => (is => 'ro');
has 'timestamp' => (is => 'ro');
has 'size'      => (is => 'ro');
has 'distinfo'  => (is => 'lazy');

sub _build_distinfo
{
    my $self = shift;

    return CPAN::DistnameInfo->new($self->path);
}

1;
