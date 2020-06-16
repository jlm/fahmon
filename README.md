[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/jlm/fahmon) 

# fahmon
Monitor a Folding@Home identity and client

fahmon is a Ruby script to monitor a Folding@Home identity and client.

## Installation
### on Ubuntu under WSL
Ruby TK on Ubuntu on WSL (Windows Subsystem for Linux) requires tweaking to install.
* Install rbenv and ruby-build (using git clone: see https://github.com/rbenv/rbenv).
```
% apt-get install libreadline-dev libssl-dev zlib1g-dev
% rbenv install 2.7.1
% rbenv global 2.7.1
% gem install bundler
```

You need an X Server.  Install VCXsrv (the one I used) or XMing.  Launch X.

#### If using Shoes
[Shoes](http://shoesrb.com/) is a graphical toolkit for Ruby.  Instead of being packaged as a gem (as Tcl/Tk is),
Shoes expects to be installed as a command (an application), and invoked (`shoes xxx.rb`) instead of invoking Ruby
directly.  Once one gets over the weirdness of this, it works well.  To use Shoes with Fahmon, just install Shoes and
invoke it as follows:
```
% shoes shoes_widget.rb
```
#### If using Tcl/Tk
(It's better to use Shoes.)
Install ActiveState Tcl 8.5 (version 8.6 is not supported).
Install a load of Ubuntu packages such as `libx11-dev` and `libxss-dev` (that was the hard one to diagnose).
Then, `gem install tk`.


### on Gitpod
Just press the 'Gitpod: Ready to Code' button above.  The FAHClient will not run in the Gitpod environment, so a mock client is started.
This emulates part of the control channel that the real FAHClient implements.  Also, TK won't install in the Gitpod environment.
Another drawback is that I can't get Ruby debugging to work on Gitpod.

