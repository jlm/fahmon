[![Gitpod Ready-to-Code](https://img.shields.io/badge/Gitpod-Ready--to--Code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/jlm/fahmon) 

# fahmon
Monitor a Folding@Home identity and client

fahmon is a Ruby script to monitor a Folding@Home identity and client.

## Installation
Ruby TK on Ubuntu on WSL (Windows Subsystem for Linux) requires tweaking to install.
* Install rbenv and ruby-build (using git clone: see https://github.com/rbenv/rbenv).
```
% apt-get install libreadline-dev libssl-dev zlib1g-dev
% rbenv install 2.7.1
% rbenv global 2.7.1
% gem install bundler
```

You need an X Server.  Install VCXsrv (the one I used) or XMing.  Launch X.
Install ActiveState Tcl 8.5 (version 8.6 is not supported).
Install a load of Ubuntu packages such as libx11-dev and libxss-dev (that was the hard one to diagnose)
gem install tk.
Done.
