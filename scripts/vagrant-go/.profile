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

# prompt adjustments
export PS1='\n——\e[1;36m\]\h\[\e[0m\]——\e[1;32m\]$(parse_git_branch)\[\e[0m\]\e[1;32m\]\n— \e[1;34m\]\w\[\e[0m\] —\n\t : '

export GOPATH=$HOME/go

# Set up go home unless we already have one
if [ ! -d "$GOPATH" ] ; then
    mkdir -p $GOPATH/bin
    ln -s /vagrant_go/src $GOPATH/src
    ln -s /vagrant_go/pkg $GOPATH/pkg
fi
# access golang executables and user executables
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

# installing dev Go tools
go get github.com/onsi/ginkgo/ginkgo
go get github.com/onsi/gomega
