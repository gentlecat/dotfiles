set -x PERL_MM_OPT "INSTALL_BASE=$HOME/perl5"
eval (perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)

set PATH ~/Library/Android/sdk/platform-tools $PATH
set PATH /usr/local/sbin $PATH
set -x GOPATH ~/workspace/go
set PATH $GOPATH/bin $PATH

eval (thefuck --alias | tr '\n' ';')

