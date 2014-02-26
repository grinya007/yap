package Yap::User;
use Mojo::Base -base;

has uid => sub { unpack('H*', pack('N', int(rand 2**32))) }; # xexe

1;
