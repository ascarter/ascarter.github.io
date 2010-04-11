--- 
layout: post
title: Finding Installed Packages On Ubuntu
date: 2010-01-15 21:44:29
---

[Ubuntu](http://ubuntu.com) uses the Debian [package](http://www.debian.org/doc/FAQ/ch-pkg_basics.en.html) system. There are multiple applications for managing the packages on your system including [Apt](http://wiki.debian.org/Apt), [aptitude](http://wiki.debian.org/Aptitude), [dpkg](http://wiki.debian.org/DebianPackageDocumentation), and [Synaptic](http://www.nongnu.org/synaptic/). Each of these tools interacts with the `deb` format package files.

Synaptic is a great tool for managing packages in a GUI. But what about the command line? I run an older Dell PowerEdge 400SC as a server literally in a closet in my house. It's got power and a network cable so I manage it over SSH from my laptop or my Ubuntu desktop. For whatever reason, I never could figure out the right way to list packages already installed. I found two methods to list the packages.

##### dpkg-query

This tool lists the installed packages as well as some other information. It accepts a pattern for finding matching packages. In addition, it can show package status and all the files included in the package.

	dpkg-query actions
	-l, --list package-name-pattern...
		List packages matching given pattern.
	-s, --status package-name...
		Report status of specified package.
	-L, --listfiles package-name...
		List files installed to your system from package-name.
	-S, --search filename-search-pattern...
		Search for a filename from installed packages.
	-p, --print-avail package-name...
		Display details about package-name, as found in
		/var/lib/dpkg/available. Users of APT-based frontends
		should use apt-cache show package-name instead.

The following is an example for the ruby package:

	$ dpkg-query --list ruby1.8
	Desired=Unknown/Install/Remove/Purge/Hold
	| Status=Not/Inst/Cfg-files/Unpacked/Failed-cfg/Half-inst/trig-aWait/Trig-pend
	|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
	||/ Name    Version            Description
	+++-=======-==================-======================================================
	ii  ruby1.8 1.8.7.174-1ubuntu1 Interpreter of object-oriented scripting language Ruby

##### apt-show-versions

Another useful tool for listing both the installed packages and information on out-of-date packages is `apt-show-versions`. It is not part of the base Ubuntu install but can easily be added:

	$ sudo apt-get install apt-show-versions

The tool has many useful query options. It can show specific packages, match by a regex pattern, and list upgradeable packages:

	Apt-Show-Versions v.0.16 (c) Christoph Martin

	Usage:
	 apt-show-versions         shows available versions of installed packages.

	Options:
	 -stf|--status-file=<file>  Use <file> as the dpkg status file instead
	                            of /var/lib/dpkg/status
	 -ld|list-dir=<directory>   Use <directory> as path to apt's list files instead
	                            of /var/state/apt/lists/ or /var/lib/apt/lists/
	 -p|--package=<package>     Print versions for <package>.
	 -r|--regex                 Read package with -p as regex
	 -R|--regex-all             Like --regex, but also show not installed packages.
	 -u|--upgradeable           Print only upgradeable packages
	 -a|--allversions           Print all available versions.
	 -b|--brief                 Short output.
	 -nh|--nohold               Don't treat holded packages.
	 -i|--initialize            Initialize or update package cache only (as root).
	 -v|--verbose               Verbose messages.
	 -h|--help                  Print this help.

Examples:

	$ apt-show-versions ruby1.8
	ruby1.8/karmic-updates uptodate 1.8.7.174-1ubuntu1

	$ apt-show-versions -a ruby1.8
	ruby1.8 1.8.7.174-1ubuntu1 install ok installed
	ruby1.8 1.8.7.174-1        karmic         us.archive.ubuntu.com
	ruby1.8 1.8.7.174-1ubuntu1 karmic-updates us.archive.ubuntu.com
	No stable version
	ruby1.8/karmic-updates uptodate 1.8.7.174-1ubuntu1
