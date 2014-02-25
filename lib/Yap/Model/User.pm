package Yap::Model::User;
use Mojo::Base -base;

use Yap::Storage;

has uid => sub { unpack('H*', pack('N', int(rand 2**32))) }; # xexe

sub pastes
{
    my ($self) = @_;
    Yap::Storage->ids_by_uid($self->uid());
}


1;
