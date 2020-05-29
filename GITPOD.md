Notes on configuring for Gitpod
===============================

Installing FAHClient
--------------------
FAHCmon is a monitor for the Folding@Home client.  So, to test it, ideally one would run that client in the
development environment.
Installing software in a Gitpod instance is not straightforward, because direct `sudo`
access is not available.  It can be done via a custom Dockerfile.  This takes a bit of getting used to, particularly
if you don't have your `.gitpod.yml` file just right: this can result in silent failures and nothing working.

Of course, installation must be non-interactive.  The FAClient has to be downloaded as a DEB file, and installed
with `dpkg`.  Before that, the installation questions must be pre-answered using `dpkg-set-selections`, which is
a non-obvious process.

Once you do get it installed, it hangs when run, because of an `Operation not permitted` error.  So I gave up on that.

Installing TK
-------------
FAHCmon uses Ruby's `tk` gem, which doesn't support `tk8.6` which is the current vertsion.  Gitpod is based on
Ubuntu 20.4 at present.  There's no gem for `tk8.5` right now.  Oh well.
