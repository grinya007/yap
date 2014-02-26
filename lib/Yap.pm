package Yap;
use Mojo::Base 'Mojolicious';

use Yap::User;

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
            $rUser = Yap::User->new(uid => $sUid);
        }
        else
        {
            $rUser = Yap::User->new();
            $c->session('uid', $rUser->uid());
        }
        $c->stash('user', $rUser);
    });

    # Router
    my $r = $self->routes;
    $r->namespaces(['Yap::Controller']);
    $r->get('/')->to('pastes#index');
    $r->post('/')->to('pastes#store');
    $r->route('/:id', id => qr/[a-f0-9]+/)->to('pastes#retrieve');
    $r->get('/history')->to('pastes#history');
}

1;
