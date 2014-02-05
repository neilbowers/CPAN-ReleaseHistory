package CPAN::ReleaseHistory::ReleaseIterator;

use Moo;
use CPAN::ReleaseHistory;
use CPAN::ReleaseHistory::Release;
use autodie;

has 'history' =>
    (
        is      => 'ro',
        default => sub { return PAUSE::Packages->new(); },
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

    my $line = <$fh>;

    if (defined($line)) {
        chomp($line);
        my ($path, $time, $size) = split(/\s+/, $line);
        return CPAN::ReleaseHistory::Release->new(path => $path, timestamp => $time, size => $size);
    } else {
        return undef;
    }
}

1;

