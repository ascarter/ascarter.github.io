--- 
layout: post
title: Ruby Version Manager
date: 2010-05-30 20:48:50
---

Framework library and dependency management is always a concern when developing software. For a rapidly changing system like [Ruby][ruby], it is an even bigger issue. Take the upcoming Rails 3 release as an example. I would like to begin using Rails 3 to create new projects. At the same time, I have existing projects I don't want to convert. You can have multiple versions of gems installed and use version references to determine which one to use. It doesn't take long before you build up a large set of gems with multiple versions. Compounding this problem, if you want to use a  different Ruby interpreter (like the 1.9.1 version), you now need to manage both the interpreter and the gems.

Thankfully, Wayne Seguin has created an excellent solution with [Ruby Version Manager][rvm]. RVM is an elegant tool for both managing the Ruby interpreter and gems. It also allows you to create custom sets of gems for your application.

RVM leverages a very basic notion in Ruby. Using the right paths, you can sandbox a Ruby interpreter and point it at any set of gems you wish. For example, you could create `/usr/local/ruby1.8` and `/usr/local/ruby1.9` directories. Inside each of those you could build a version of ruby and then install a separate version of Rubygems. By setting the paths correctly, you can run two different configurations.

That's the basic idea behind RVM. I created a crude version of this for our production system. We install what we need into a user space account and use environment settings to control what is run. Our solution is hand-crafted and is not very flexible. It was custom built for our specific application. Using it again would take a fair amount of work.

I'm sure I'm not the only one to come up with something like this. Many other people likely have their own variation of this approach. If you have done any work with Java, this should sound very familiar (installing a specific JDK/JRE for an application).

RVM does the same thing while providing a wonderful set of tools and management utilities. It is so good that I think the best approach for Ruby development is to take a clean machine and install RVM before writing a single line of code.

I recently have been switching over all my development to using RVM. I had to undo my previous setup on my primary development machine (MacBook Pro) since I had lots of installed gems for various projects. I plan to roll RVM out to our test and production environments once I get a little more familiar with it.

RVM runs on Mac OS X, Linux, Solaris, and any other Unix-based environment. My notes are from converting my MacBook Pro to using RVM. For the most part, these instructions should work just fine on Linux.

# Restore default gems

If you have been developing with Ruby on Rails for some time, you likely have added numerous gems to your system install. You don't have to touch it if you don't want to. RVM supports the default system install. Additionally, system components have begun to use Ruby. It is likely you will now have software that expects a version of Ruby to be installed.

I decided I wanted to sandbox all my Rails development and restore my system to the original Ruby install. I figure I can get the best of both worlds. I have a system version of Ruby that I can always fall back on while setting up any number of Ruby configurations for development and experimentation.

It turns out to be easy to restore a Mac to the default configuration. Apple has divided the standard ruby install into several directories. The system versions are masked when you install gems or update. The two directories involved are `/usr/lib/ruby/site_ruby` and `/usr/lib/ruby/user-gems`. These two directories in reality are symlinks to directories in `/Library/Ruby`. These are what you need to cleanup to get back to the defaults which are kept in `/usr/lib/ruby/1.8` and `/usr/lib/ruby/gems`. If you want to play it safe, you can tar ball the entire `/usr/lib/ruby` directory first. You can also go through and uninstall each gem individually.

	$ cd /usr/lib/ruby/site_ruby/1.8
	$ sudo rm -Rf gauntlet_rubygems.rb rbconfig/ rubygems/ rubygems.rb ubygems.rb
	$ cd ../../user-gems/1.8
	$ sudo rm -Rf */**

Now you should have a Ruby setup that looks just like a new Snow Leopard install. It is likely the last time you will use the Apple supplied version of Ruby.

# Install and setup

RVM can be installed from source or via a gem. Wayne takes an unusual approach for supporting RVM. If you catch him on IRC, he will often fix the problem right there and commit the fix to the GitHub repository. Consequently, it is best to install directly from GitHub in order to easily pull changes.

There is a bootstrap script that you can run to get RVM installed. It will create a `~/.rvm` directory, use git to clone the repository, and check it out:

	$ bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )

Once it is installed, you should update your shell profile. You need to run the RVM script to add it to the path and initialize the RVM environment. You can also optionally add the RVM environment to your prompt and add bash completion. The following can be added to your `~/.bashrc`:

	if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then source "$HOME/.rvm/scripts/rvm" ; fi
	PS1="\$(~/.rvm/bin/rvm-prompt) $PS1"
	if [[ -r $rvm_path/scripts/completion ]] ; then source $rvm_path/scripts/completion ; fi

After install, you can update RVM itself at any time using the following command:

	$ rvm update --head

This will update the git enlistment and update any RVM components.

# RVM Command Line

All commands follow a standard structure:

	rvm action [interpreter] [flags] [options]

Use `rvm --help` will explain all the available commands.

The available interpreters include the following:

	ruby      - MRI/YARV Ruby {1.8.6,1.8.7,1.9.1,1.9.2...}
	jruby     - JRuby, Ruby interpreter on the Java Virtual Machine.
	rbx       - Rubinius
	ree       - Ruby Enterprise Edition
	macruby   - MacRuby
	maglev    - GemStone Ruby
	mput      - shyouhei(mput)'s github repository
	system    - use the system ruby (eg. pre-rvm state)
	default   - use rvm set default ruby and system if it hasn't been set.

As you can see, all the important Ruby implementations are available. You are able to pick which interpreter and version you want to use. RVM will download the source and build it. Then it will create a private gem instance for any interpreter installed.

# Install a Ruby Interpreter

Installing a specific Ruby is easy. The following commands install two different Ruby interpreters:

	$ rvm install ruby-1.8.7
	$ rvm install ruby-1.9.1-p378

After install, you will now have Ruby version 1.8.7p238 and Ruby 1.9.1p378. Use `rvm list` to see what is installed:

	$ rvm list

	rvm rubies

	=> ruby-1.8.7-p249 [ x86_64 ]
	   ruby-1.9.1-p378 [ x86_64 ]

When installing, you can provide just a version number to get the current stable version for that line. You provide a specific patch version as well.

To use a ruby version:

	$ rvm use ruby-1.9.1-p378
	$ ruby --version
	Using ruby 1.9.1 p378
	$ ruby --version
	ruby 1.9.1p378 (2010-01-10 revision 26273) [i386-darwin10.3.0]

You now are using Ruby 1.9.1 instead of the system version.

To choose a default:

	$ rvm --default ruby-1.8.7

# Gemsets

Now that you can install multiple version of the ruby interpreter, the next step is to manage gems. When installing, a base set of gems is automatically setup. By default, the only gems are:

	$ gem list

	*** LOCAL GEMS ***

	rake (0.8.7)
	rdoc (2.5.8)

The standard gem commands are used to install other gems just like normal. The one thing to keep in mind is that these run in **user space** - you don't need to use `sudo` for any of them.

It gets even better. You can also define custom sets of gems. This means you can swap out completely different gem configurations easily. For example, you might want to test your application against multiple versions of Rails. Create a separate gemset for each Rails version and then swap them out to test them.

	$ rvm gemset create rails238 rails222
	$ rvm ruby-1.8.7@rails238
	$ gem install rails -v 2.3.8
	$ rvm ruby-1.8.7@rails222
	$ gem install rails -v 2.2.2

Gemsets can be copied, exported, and imported as well. The special gemset `@global` is a template used when creating a gemset.

# Per-Project RVM

The last thing I'll explain is using RVM at the project level. This is an incredibly powerful feature. Using a file in the root of your project, you can automatically run a ruby interpreter and gemset anytime you change to that path.

Example:

	$ rvm ruby-1.8.7@rails238
	$ cd Projects
	$ rails mytestproject
	$ echo "rvm ruby-1.8.7@rails238" > mytestproject/.rvmrc
	$ rvm ruby-1.8.7@rails222
	$ rails --version
	Rails 2.2.2
	$ cd mytestproject
	$ rails --version
	Rails 2.3.8
	$ gem env gemdir
	/Users/andrew/.rvm/gems/ruby-1.8.7-p249@rails2.3.8

# Using RVM in Dev, Test, and Production

Using RVM for development is a major asset. It becomes much easier to manage multiple versions as well as experiment with new features. These attributes can carry over into Test and Production as well. It can be used to stabilize the base Ruby configuration you use in each environment. Since it can bootstrap itself via source installs, it is easy to script and setup. It also normally runs in user space instead of privileged root. This is a major security advantage.

The RVM website has lots more information. I've barely scratched the surface. The RVM project is extremely active and should be a primary tool for any Rails developer.

[ruby]: http://www.ruby-lang.org
[rvm]: http://rvm.beginrescueend.com/