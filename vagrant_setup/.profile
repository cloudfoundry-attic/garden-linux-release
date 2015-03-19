# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
  . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

source $HOME/.functions

export GOHOME=$HOME/go

# Set up go home unless we already have one
if [ ! -d "$GOHOME" ] ; then
    mkdir -p $GOHOME/bin
    ln -s /vagrant_go_src $GOHOME/src
    ln -s /vagrant_go_pkg $GOHOME/pkg
fi
# access golang executables and user executables
export PATH=$PATH:$GOHOME/bin:/usr/local/go/bin

# set (trivial) GOPATH
export GOPATH=$GOHOME
