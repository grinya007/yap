package Yap::Controller::Pastes;
use Mojo::Base 'Mojolicious::Controller';

use Yap::Storage;

sub history 
{
    my ($self) = @_;
    $self->render
    (
        format => 'json', 
        json => Yap::Storage->ids_by_uid($self->stash('user')->uid())
    );
}

sub store
{
    my ($self) = @_;
    my $sId = Yap::Storage->put_content
    (
        $self->param('content'), 
        $self->stash('user')->uid()
    );
    $self->render(format => 'text', text => $sId || '');
}

sub retrieve
{
    my ($self) = @_;
    my $sContent = Yap::Storage->content_by_id($self->stash('id'));
    $self->render_not_found() if !$sContent;
    $self->render(format => 'text', text => $sContent);
}

1;
