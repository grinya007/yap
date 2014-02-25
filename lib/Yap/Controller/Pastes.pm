package Yap::Controller::Pastes;
use Mojo::Base 'Mojolicious::Controller';

use Yap::Storage;

sub history 
{
    my ($self) = @_;
    $self->render(format => 'json', json => { history => $self->stash('user')->pastes() });
}

sub store
{
    my ($self) = @_;
}

sub retrieve
{
    my ($self) = @_;
    my $sContent = Yap::Storage->content_by_id($self->stash('id'));
    $self->render_not_found() if !$sContent;
    $self->render(format => 'text', text => $sContent);
}

1;
