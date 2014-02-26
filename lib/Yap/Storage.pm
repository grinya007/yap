package Yap::Storage;

my $_sDir = 'storage/';

sub ids_by_uid
{
    my ($sClass, $sUid) = @_;
    die 'bad args' if $sUid !~ /^[a-f0-9]+$/;
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

sub content_by_id
{
    my ($sClass, $sId) = @_;
    die 'bad args' if $sId !~ /^[a-f0-9]+$/;
    my ($sFile) = <${_sDir}*_$sId>;
    return undef if !$sFile;
    return join('', `cat $sFile`);
}

sub put_content
{
    my ($sClass, $sContent, $sUid) = @_;
    my $sId = unpack('H*', pack('N', int(rand 2**32)));
    my $sFile = $_sDir.$sUid.'_'.$sId;
    open(F, '>', $sFile) || return undef;
    print F $sContent;
    close F;
    return $sId;
}

1;
