package CPAN::ReleaseHistory::ReleaseIterator;

use Moo;
use CPAN::ReleaseHistory;
use CPAN::ReleaseHistory::Release;
use CPAN::DistnameInfo;
use autodie;

has 'history' =>
    (
        is      => 'ro',
        default => sub { return PAUSE::Packages->new(); },
    );

has 'well_formed' =>
    (
        is      => 'ro',
        default => sub { 0 },
    );

has _fh => ( is => 'rw' );

sub next_release
{
    my $self = shift;
    my $fh;

    if (not defined $self->_fh) {
        open($fh, '<', $self->history->path());
        $self->_fh($fh);
    }
    else {
        $fh = $self->_fh;
    }

    RELEASE:
    while ( my $line = <$fh> ) {
        chomp($line);
        my ($path, $time, $size) = split(/\s+/, $line);
        my @args                 = (path => $path, timestamp => $time, size => $size);

        if ($self->well_formed) {
            my $distinfo = CPAN::DistnameInfo->new($path);

            next RELEASE unless defined($distinfo)
                     && defined($distinfo->dist)
                     && defined($distinfo->cpanid);
            push(@args, distinfo => $distinfo);
        }

        return CPAN::ReleaseHistory::Release->new(@args);
    }

    return undef;
}

1;

