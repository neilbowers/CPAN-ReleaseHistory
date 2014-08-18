package CPAN::ReleaseHistory::Release;

use Moo;
use CPAN::DistnameInfo;

has 'path'      => (is => 'ro');
has 'timestamp' => (is => 'ro');
has 'size'      => (is => 'ro');
has 'distinfo'  => (is => 'lazy');
has 'date'      => (is => 'lazy');

sub _build_distinfo
{
    my $self = shift;

    return CPAN::DistnameInfo->new($self->path);
}

sub _build_date
{
    my $self = shift;
    my @gmt  = gmtime($self->timestamp);

    return sprintf('%d-%.2d-%.2d', $gmt[5]+1900, $gmt[4]+1, $gmt[3]);
}

1;
