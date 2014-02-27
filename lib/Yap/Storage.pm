package Yap::Storage;

my $_sDir = 'storage/';
my $_reId = qr/^[a-f0-9]{8}$/;

sub get_ids_by_uid
{
    my ($sClass, $sUid) = @_;
    die 'bad args' if $sUid !~ $_reId;
    my $sPrefix = $_sDir.$sUid.'_';
    return 
    [
        map
        {
            my $iCtime = (stat)[9];
            s/^$sPrefix//;
            [$iCtime, $_];
        }
        <${sPrefix}*>
    ];
}

sub get_content_by_id
{
    my ($sClass, $sId) = @_;
    die 'bad args' if $sId !~ $_reId;
    my ($sFile) = <${_sDir}*_$sId>;
    return undef if !$sFile;
    open(F, $sFile) || return undef;
    binmode F, ':utf8';
    return join('', <F>);
}

sub put_content
{
    my ($sClass, $sContent, $sUid) = @_;
    my $sId = unpack('H*', pack('N', int(rand 2**32)));
    my $sFile = $_sDir.$sUid.'_'.$sId;
    open(F, '>', $sFile) || return undef;
    binmode F, ':utf8';
    print F $sContent;
    close F;
    return $sId;
}

sub delete_content_by_id
{
    my ($sClass, $sId, $sUid) = @_;
    die 'bad args' if $sId !~ $_reId;
    die 'bad args' if $sUid !~ $_reId;
    my $sFile = $_sDir.$sUid.'_'.$sId;
    return unlink $sFile;
}

1;
