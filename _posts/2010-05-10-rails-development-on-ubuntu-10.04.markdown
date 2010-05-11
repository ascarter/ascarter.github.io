--- 
layout: post
title: Rails Development on Ubuntu 10.04
date: 2010-05-10 22:31:33
---

April means a new release of [Ubuntu][ubuntu]. This time is version 10.04 which is also a long term release. It should be a particularly good version to adopt given the long support cycle.

I previously posted my recipe for setting up [Rails on Ubuntu 9.10][rails-9.10]. Most of the recipe is still valid. For convenience, I'm reposting the entire recipe with updates for Ubuntu 10.04

**Disclaimer:**

> This recipe is based on my own experience and is what I recommend. You will find many other ways to do this. I highly recommend you study each step and understand what packages or functionality you are enabling. When it comes time to deploy to production, you want a minimal configuration.

# Assumptions

The steps are done assuming a new clean install of Ubuntu 10.04. I use 64-bit Alternate for my installs. It should be nearly identical for 32-bit, Desktop, and Server installs as well. I'll use `apt-*` commands so you can do everything from the command line. Use synaptic or dpkg if you wish.

# Pre-requisites

By default, Ubuntu now ships with GCC and everything you need to compile out of the box. I found you no longer need to install any packages to start compiling. Inclusion of a **C** compiler should be a basic computing right. No computer should ever be without one.

# Ruby

Ubuntu 10.04 includes both Ruby 1.8 and 1.9 in the package system. Ruby 1.8 is still more widely used for Rails development. With Rails 3 looming on the horizon, Ruby 1.9 finally looks poised to take over. I think it is highly likely Ruby 1.9.2 and Rails 3 will be the standard configuration by the end of 2010. Until then, you should stick with Ruby 1.8. Note that you can install Ruby 1.8 and 1.9 side by side. However, a much better solution is to use [Ruby Version Manager (RVM)][rvm] instead. RVM lets you install Ruby and matching gems for multiple verisons. More on this later but it is definitely the way to go.

For now, install the default Ruby 1.8 stack. This allows you to get up and running. Also, other non-Rails packages may need Ruby support. It is good to have Ruby 1.8 as a base Ruby install for things other than development.

There are a couple other libraries you should install from packages as well. These include native libraries for SSL and readline. I also install RDoc, RI and irb from packages. You need to install `ruby-dev` to be able to compile native ruby gems later.

Here's the install for the ruby stack:

	sudo apt-get install irb libopenssl-ruby libreadline-ruby rdoc ri ruby ruby-dev

Another optional install is the first edition of the [Ruby Book][rubybook]. It might be handy but you do have a [newer version][rubybook1.9] than that don't you?

	sudo apt-get install rubybook

It will be installed to:

	/usr/share/doc/rubybook/html/index.html

# Rubygems

So far, setup has been easy since everything comes from the package system. Now we start to deviate. Rubygems has been a [source of contention][debian-rubygems-policy] between Debian and the Rubygems developers. The core problem is that both are package systems. Rubygems can (and arguably should) manage all gem packages. On Debian systems, dpkg should own all the packages installed in the system. This could include  gems as well. This is where the friction starts.

No matter which side of the argument you might find yourself, the good news is that installing rubygems from source is easy. Building it installs in the system location anyway since that is where Ruby already is installed. The net result is basically the same. The advantage is you can update Rubygems directly. The package system will trail far behind new gem builds.

**My rule for gems:**

> *Only use apt to install supporting C-libraries to allow native gems to build. Install gems themselves via a source install for rubygems.*

When I build from source and install to the system, I prefer to put the source in `/usr/local/src`. But feel free to install anywhere you like. To install rubygems, you need to download the latest tarball. As of this writing, it is 1.3.6. Then extract the archive and install:

	cd /usr/local/src
	wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.6.tgz
	tar xzvf rubygems-1.3.6.tgz
	cd rubygems-1.3.6
	sudo ruby setup.rb

The gem binary is now installed:

	/usr/bin/gem1.8

If you want to have `gem` point to the 1.8 binary:

	sudo update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.8 1

Next, run a gem system update to be sure you are on the latest version:

	sudo gem update --system

Rubygems should now be installed and ready to go.

# Rails and Other Gems

Rubygems installs dependencies automatically. Installing the Rails gem which will bring in ActionPack, ActiveRecord, and other supporting gems. 

	sudo gem install rails SystemTimer ruby-debug ruby-debug-ide

The following are a few useful tools that are delivered via gems:

	sudo gem install cheat ghost gist

### ImageMagick/RMagick

Unlike on Mac OS X, [ImageMagick][imagemagick] and [RMagick][rmagick] are very easy to install:

	sudo apt-get install imagemagick libmagickcore-dev
	sudo gem install rmagick

# Databases

The database landscape is changing. Choices in the RDMS space have become more complicated. The rise of document oriented storage systems (aka NoSQL) has added yet another dimension.

For most developers, RDMS is likely the best choice. You should install two different database systems. One is for development and the other is for production.

If you can, you should use [SQLite][sqlite] for doing development. It requires no configuration and is well supported by Rails. You will never **ever** go to production on SQLite. The lack of concurrency is a deal breaker.

For production, you will want a traditionally client/server RDBMS system. The two most popular are [MySQL][mysql] and [PostgreSQL][postgresql]. [Oracle][oracle] is another choice if your company is already invested heavily in Oracle. The open source RDBMS systems are better supported since more developers have access to them.

This is a religious topic. There are of course numbers that can prove one is better than another. But cost is likely a large consideration. Other issues include support and licensing. I've used MySQL, PostgreSQL, and Oracle in Rails projects (and SQL Server extensively for non-Rails/.NET projects).

Until recently, MySQL has been my recommendation. However, I've personally been moving away from MySQL and onto PostgreSQL. I'm writing that up as a separate future post. For now, I'll provide instructions to setup the basic infrastructure.


### SQLite

SQLite is now the default database a Rails application will use. It is easy since the database is kept in a local file and doesn't require any server setup. Note that SQLite is not a good choice if you need to do concurrency development of any kind. SQLite is not a server. Sharing the database on multiple instances of your Rails app isn't going to go well.

SQLite is fully supported in the Ubuntu package system. Install the SQLite binaries and libraries, then install the native SQLite gem:

	sudo apt-get install libsqlite3-dev sqlite3 sqlite3-doc
	sudo gem install sqlite3-ruby


### MySQL

Unlike on the Mac, MySQL is very easy to setup on Ubuntu. For 10.04, MySQL 5.1 is the default:

	sudo apt-get install libmysqlclient-dev mysql-server
	sudo gem install mysql


### PostgreSQL

Using PostgreSQL locally is also relatively easy to get up and running. For 10.04, PostgreSQL 8.4.3 is the default.

	sudo apt-get install postgresql postgresql-client postgresql-doc pgadmin3
	sudo gem install pg


# Final Thoughts

Ubuntu continues to be a great choice for Ruby on Rails development and deployment. It is very nice to have the same configuration on your Ubuntu desktop and server. Beyond the boot strap phase, most of the rest of your interaction will be via gems.

I did not cover application server choices yet. The most likely choices are [Thin][thin], [Passenger][passenger], or [Unicorn][unicorn]. I'll be writing those up in the near future.

[ubuntu]: http://ubuntu.com/
[rails-9.10]: http://ascarter.net/2010/01/04/rails-development-on-ubuntu-9.10.html
[rvm]: http://rvm.beginrescueend.com/
[rubybook]: http://www.ruby-doc.org/docs/ProgrammingRuby/
[rubybook1.9]: http://www.pragprog.com/titles/ruby3/programming-ruby-1-9
[debian-rubygems-policy]: http://pkg-ruby-extras.alioth.debian.org/rubygems.html
[imagemagick]: http://www.imagemagick.org/
[rmagick]: http://rmagick.rubyforge.org/
[sqlite]: http://sqlite.org
[mysql]: http://mysql.com
[postgresql]: http://postgresql.org
[oracle]: http://oracle.com
[thin]: http://code.macournoyer.com/thin/
[passenger]: http://www.modrails.com/
[unicorn]: http://unicorn.bogomips.org/
