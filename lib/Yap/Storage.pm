package Yap::Storage;

my $sDir = 'storage/';

sub ids_by_uid
{
    my ($sClass, $sUid) = @_;
    my $sPrefix = $sDir.$sUid.'_';
    return 
    [
        map
        {
            s/^$sPrefix//;
            $_
        }
        <${sPrefix}*>
    ];
}

sub content_by_id
{
    my ($sClass, $sId) = @_;
    die 'bad args' if $sId !~ /^[a-f0-9]+$/;
    my ($sFile) = <${sDir}*_$sId>;
    return undef if !$sFile;
    return join('', `cat $sFile`);
}

1;
