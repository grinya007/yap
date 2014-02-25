package Yap;
use Mojo::Base 'Mojolicious';

use Yap::Model::User;

sub startup 
{
    my $self = shift;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer');

    $self->secrets([join('', `cat .mojo_secret`)]);
    $self->hook(before_dispatch => sub
    {
        my ($c) = @_;
        my $rUser;
        my $sUid = $c->session('uid');
        if ($sUid)
        {
            $rUser = Yap::Model::User->new(uid => $sUid);
        }
        else
        {
            $rUser = Yap::Model::User->new();
            $c->session('uid', $rUser->uid());
        }
        $c->stash('user', $rUser);
    });

    # Router
    my $r = $self->routes;
    $r->namespaces(['Yap::Controller']);
    $r->get('/')->to('pastes#history');
    $r->post('/')->to('pastes#store');
    $r->route('/:id', id => qr/[a-f0-9]+/)->to('pastes#retrieve');
}

1;
