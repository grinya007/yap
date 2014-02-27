yap
===

yet another pastebin

    sudo cpan -i Carton
    git clone https://github.com/grinya007/yap.git
    cd yap
    ./install.sh
    carton exec './script/yap prefork -P /tmp/yap.pid -l http://*:8080'
