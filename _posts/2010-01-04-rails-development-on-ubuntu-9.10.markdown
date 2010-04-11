--- 
layout: post
title: Rails Development on Ubuntu 9.10
date: 2010-01-04 23:03:49
---

I use both Mac OS X and Ubuntu Linux for [Ruby on Rails](http://rubyonrails.org) devleopment. In both cases, setting up an environment is relatively easy but not without some pitfalls. I've been using Rails on Mac OS X since Tiger 10.5 and on Ubuntu since 7.10. I've kept [Backpack pages](http://www.backpackit.com) with my recipes for how to set it up. This post will explain how to setup Ruby on Rails for [Ubuntu 9.10](http://ww.ubuntu.com). It's certainly not the only way and it's obviously biased by my preferences. But I've used this recipe successfully over several ubuntu releases.

So with that out of the way, let's get Ruby on Rails up on Ubuntu.

# Assumptions

The steps are done assuming a new clean install of Ubuntu 9.10. I use 64-bit Alternate typically for my installs but it should be nearly identical both for 32-bit and/or Desktop installs. Also, I'll use `apt-*` commands. Use synaptic or dpkg if you wish.

# Pre-requisites

By default, you will have minimal development tools available. The first thing to do is install the primary tool chain. This is mostly gcc and common development libraries. In Ubuntu, many packages have a `lib*-dev` version that includes headers and the libraries needed for linking. Fortunately, it's very easy to get the default gcc installed:

	sudo apt-get install build-essential

The package `build-essential` is a metapackage that includes gcc and all the supporting libraries and tools. It's very much like installing Xcode on a Mac. You now will have all the compilers and are ready to build most source that is packaged via autoconf.

# Ruby

Ubuntu 9.10 includes both Ruby 1.8 and 1.9 in the package system. At this time, Ruby 1.8 is still more widely used for Rails development. Hopefully that will change soon since Ruby 1.9 has many great improvements.

I generally have used the packaged ruby installs for Ubuntu. There aren't many configuration options you would tweak when building ruby so it's only a question of the ruby version that would make you want to install from source in my opinion.

There are a couple other libraries you should install from packages as well. These include native libraries for SSL and zlib. I also install RDoc, RI and irb from packages. You also should install `ruby-dev` to be able to compile native ruby gems later.

Here's the install for the ruby stack:

	sudo apt-get install ruby rdoc ri irb libyaml-ruby libzlib-ruby libopenssl-ruby ruby-dev

Another optional install is the first edition of the [Ruby Book](http://www.ruby-doc.org/docs/ProgrammingRuby/). It might be handy but you do have a [newer version](http://www.pragprog.com/titles/ruby3/programming-ruby-1-9) than that don't you?

	sudo apt-get install rubybook

It will be installed to:

	/usr/share/doc/rubybook/html/index.html

# Rubygems

So far, setup has been easy since everything comes from the package system. Now we start to deviate. Rubygems has been a [source of contention](http://pkg-ruby-extras.alioth.debian.org/rubygems.html) between Debian and the Rubygems developers. The core problem is that both are package systems. Rubygems can (and arguably should) manage all gem packages. On Debian systems, dpkg should own all the packages installed in the system. This could include  gems as well. This is where the friction starts.

No matter which side of the argument you might find yourself, the good news is that installing rubygems from source is easy and it puts it in the system location anyway since that is where Ruby already is installed.

My rule for gems: *Only use apt to install supporting C-libraries to allow native gems to build. Install gems themselves via a source install for rubygems.*

For locally built source that I install (i.e. to `/usr/local`), I prefer to put the source in `/usr/local/src`. But feel free to install anywhere you like.

To install rubygems, you need to download the latest tarball. As of this writing, it is 1.3.5. Then extract the archive and install:

	cd /usr/local/src
	wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz
	tar xzvf rubygems-1.3.5.tgz
	cd rubygems-1.3.5
	sudo ruby setup.rb

The gem binary is now installed:

	/usr/bin/gem1.8

If you want to have `gem` point to the 1.8 binary:

	sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.8 1

Next, run a gem system update to be sure you are on the latest version:

	sudo gem update --system

Rubygems should now be installed and ready to go.

# Rails and Other Gems

Rubygems installs dependencies automatically. Installing the Rails gem which will bring in ActionPack, ActiveRecord, and other supporting gems. Additionally, you might want to install a few other useful gems for development:

	sudo gem install rails SystemTimer ruby-debug ruby-debug-ide

### SQLite

SQLite is now the default database a Rails application will use. It is easy to use since the database is kept in a local file and doesn't require any server setup. We'll setup MySQL later in this recipe so if you need that as well, you'll be covered. Note that SQLite is not a good choice if you need to do concurrency development of any kind. SQLite is not a server and sharing the database on multiple instances of your Rails app isn't going to go well.

SQLite is fully supported in the Ubuntu package system. Install the SQLite binaries and libraries, then install the native SQLite gem:

	sudo apt-get install libsqlite3-dev sqlite3 sqlite3-doc
	sudo gem install sqlite3-ruby

# Other useful libraries

There are some optional libraries that many people use for Rails. Skip either of these if you don't need them.

### MySQL

Unlike on the Mac, [MySQL](http://mysql.com) is very easy to setup on Ubuntu. For 9.10, MySQL 5.1 is the default:

	sudo apt-get install libmysqlclient-dev mysql-server
	sudo gem install mysql

### ImageMagick/RMagick

Again, unlike on the Mac, [ImageMagick](http://www.imagemagick.org) and [RMagick](http://rmagick.rubyforge.org/) are very easy to install:

	sudo apt-get install imagemagick libmagickcore-dev
	sudo gem install rmagick

# Final Thoughts

One thing that is good to learn is how Ruby interacts with the underlying system as well as how to separate who installs what. Usually, most code is pure ruby and is very easy to install via gems.

I'll follow up this post with a recipe for getting [Passenger](http://www.modrails.com/) up and running on Ubuntu. Passenger is a fantastic way to do Rails development. It is likely going to mirror how you deploy code in production as well. I'm a big fan of running development as close to production as you can to minimize surprises.