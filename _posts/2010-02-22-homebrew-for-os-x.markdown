--- 
layout: post
title: Homebrew for OS X
date: 2010-02-22 22:10:58
---

Most Unix-based platforms have at least one package management system. Some are like [Debian](http://debian.org) where the package system is one with the operating system. Others are bolted onto the system.

Mac OS X has had two package systems for many years. [Fink](http://www.finkproject.org) is a port of the Debian apt system. [Macports](http://www.macports.org) is primarily a port of the [FreeBSD](http://www.freebsd.org) ports system. Unlike Linux, both of these are sandboxes that you run on top of the Apple supplied system. In many ways, this is not unlike [Cygwin](http://www.cygwin.com) for Windows.

In my opinion, both Fink and Macports suffer from the fact that neither makes an effort to integrate with the core operating system. I already have a tested version of Perl or Python on my system. I'd rather the package system stuck with this as much as possible.

Now there is a new package manager on the scene called [Homebrew](http://github.com/mxcl/homebrew). I think it is very promising. It is similar in approach to Macports in that you build recipes in a high level scripting language. Macports uses [TCL](http://www.tcl.tk/) and Homebrew uses my favorite language [Ruby](http://ruby-lang.org). Both pull down a source package, configure it, and build the code. Both also manage dependencies and attempt to get other supporting libraries.

There are three major differences. The first is that Homebrew is trying to augment the existing Mac OS X distribution from Apple. It uses what is already installed as much as it can. The other difference is that recipe development is very simple using Ruby. The last major improvement is that Homebrew is developed on [GitHub](http://github.com) so forking and submitting recipes is trivial.

Changes to Default Install
==========================

I've spent some time getting familiar with Homebrew the past week or so. I like what I've seen but I don't completely agree with the recommended installation. I'm offering my approach as an alternate.

There are two things I don't agree with. The first is installing Homebrew in `/usr/local`. Although Mac OS X surprisingly doesn't ship with a default `/usr/local` directory, this path has such strong meaning to anyone who uses other Unix systems like Linux. I absolutely expect to download the source to `/usr/local/src` and build it by hand.

The second recommendation I don't agree with is to make the Homebrew directory user owned instead of root. This is probably more a matter of preference but I'd rather mimic the typical behavior of root owning software available system wide. The reasons the Homebrew team give are valid but I guess I'm stuck in my ways.

Setting up Homebrew
===================

The author of Homebrew made a very good decision to allow it to be installed anywhere you want. So the first thing to do is pick where you want your Homebrew install to live. The approach is to put the software into a special directory called `HOMEBREW_PATH/Cellar`. Any binaries are symlinked in `HOMEBREW/bin`.

I recommend emulating what Macports does and creating a standalone location for Homebrew. I picked `/opt/homebrew` for my install but you can chose whatever you want. I also use root as the owner so my commands will be using `sudo`.

	sudo mkdir -p /opt/homebrew
	
Next, bootstrap an initial install of Homebrew. You can either `git clone` the repository directory or pull down a tarball of the master branch:

	sudo -s
	cd /opt
	curl -L http://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C homebrew
	
Since I've chosen to install Homebrew into its own directory, I need to make the paths available. Mac OS X uses `path_helper` as a way of defining the `PATH` and `MANPATH` settings. The `path_helper` will read `/etc/paths` and all entries in `/etc/paths.d`. The files are nothing more than a path to add separated by newline. There is a similar arrangement of `/etc/manpaths` and `/etc/manpaths.d`. If you prefer, you can just add these to your `PATH` and `MANPATH` variable in your profile:

	sudo -s
	echo "/opt/homebrew/bin" > /etc/paths.d/homebrew
	echo "/opt/homebrew/share/man" > /etc/manpaths.d/homebrew
	
Start up a new shell and test out brew:

	sudo brew list
	
You should see nothing installed. Now try installing a package:

	sudo brew install wget

When it is complete, you should have a `/opt/homebrew/bin/wget` symlinked to the binary. There are the typical package options (search, install, uninstall, list). Commands are in the form of `brew action formula`.

The recipes files are simply Ruby scripts in the `HOMEBREW/Library/Formula` directory. These files can be updated. To convert your Homebrew to a git clone:

	sudo brew update

Your Homebrew directory is now a git clone of the project. This means you can do all the normal cool git activities you want. Create a new branch to test out formula changes. Track other user's formulas by adding a git remote. Merge as you please. It is extremely flexible and elegant.

Homebrew is relatively new. The package list is much smaller than Fink or Macports. But there is a lot of activity around the project and I've already had great interactions with other users creating packages.

I think the advantage of my layout is that Homebrew is isolated cleanly and I can selectively use it to add packages. I can still install and build software to `/usr/local` with no conflicts. For example, I prefer the binary MySQL and Git installs over using the packages since I rely on these packages and don't want to deal with any issues building them. For other software like ImageMagick or ffmpeg, Homebrew is a great way to easily add it and keep it up to date.

