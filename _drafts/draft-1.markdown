---
layout: post
title: Modern Ruby Development
---

[Rails][rails] and [Ruby][ruby] have changed dramatically since the early days. For those of us that have been building software on Ruby and Rails for some time, our stack is likely due for an upgrade. Recently two things got me to reevaluate how I build Rails apps. First, I have a new project that I can use Rails to build it. The other event was the release of [rbenv] as an alternative to [RVM][rvm].

I want to outline how I now setup my development environment for Rails. It is very similar to the configuration that 37signals [recently described][37signals_setup].

Pre-requisites
==============

The following assumes you are using Mac OS X. Most of it will also likely work fine under Linux (like Ubuntu). I have no idea nor do I care if it works on Windows. If you are using Windows for your Rails development, I think you are at a severe disadvantage. That's just reality.

Software Stack
==============

zsh
---

Mac OS X defaults the terminal shell to [bash]. It also ships with a relatively up-to-date [zsh]. I recommend learning and using zsh. It has nearly no disadvantages compared with bash and has numerous programmer friendly features.

If you want to set your login shell to zsh, go to System Preferences -> Users and Groups. Right-click on your user account and select Advanced Options. Change the login shell dropdown to `/bin/zsh`.

Homebrew
--------

In my opinion, the biggest flaw of Mac OS X is the lack of a proper package manager. No mainstream Linux distribution is without a system to manage adding open source software. Given the lack of an official option from Apple, there are several community projects for managing software. The best these days is [Homebrew][homebrew]. None of the default Ruby and Rails stack requires Homebrew. However, it is highly likely you will soon encounter a dependency that requires a library (like ImageMagick).

ruby-build
----------

rbenv
-----

Bundler
-------

Pow
---

Capistrano
----------

Rails
-----



Walkthrough
===========

Given the above stack, here is a guided Walkthrough of how to configure your machine. Ideally, get your machine into a clean configuration state. If you have experimented with tools like [RVM][rvm], make sure you clean up.


Ruby Environment
----------------

*Uninstall RVM*
  
    % rvm implode


*Clone rbenv*

    git clone git://github.com/sstephenson/rbenv.git ~/.rbenv  
    
*Add rbenv and shims to PATH and enable autocompletion*

    # Add following lines to .zshrc for zsh
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

*Restart your shell*

rbenv should now be available.

*Clone and install ruby-build*

    % git clone git://github.com/sstephenson/ruby-build.git
    % cd ruby-build
    % sudo ./install.sh

The ruby-build tool is installed to `/usr/local`. Also, a new `rbenv install` command is available to install ruby builds to rbenv.

*List available versions of Ruby*

    % rbenv install
    usage: rbenv install VERSION
           rbenv install /path/to/definition
    
    Available versions:
      1.8.6-p420
      1.8.7-p249
      1.8.7-p352
      1.9.1-p378
      1.9.2-p290
      1.9.3-dev
      1.9.3-preview1
      jruby-1.6.3
      jruby-1.6.4
      rbx-1.2.4
      rbx-2.0.0-dev
      ree-1.8.7-2011.03

*Install a Ruby version*

    % rbenv install 1.9.2-p290

*Rebuild rbenv shim binaries*

This must be done every time a new Ruby is installed. Also run if gems that have binaries are installed.

    % rbenv rehash

*Set global Ruby*

If you want to use something other than the system Ruby as the default:

    % rbenv global 1.9.2-p290
    
*Set local Ruby for a project*

    % cd my_project
    % rbenv local 1.9.2-p290

*Update rubygems and default gems*

    # Assumes that you are running under the Ruby version you want to update
    % gem update --system
    % gem update

*Install bundler*

    % gem install bundler
    

Configure a Ruby Application
----------------------------

1. Create a Gemfile at root of your project

    source "http://rubygems.org"
    gem "jekyll"

2. Install gems via bundler to a local vendor directory. Create binary stubs so you can use `bin/command` instead of `bundle exec`.

    % bundle install --path vendor/bundle
    % bundle install --binstubs

3. Configure source control for bundler

    % echo ".bundle\nvendor/bundle/ruby\n" >> .gitignore
    % git add Gemfile Gemfile.lock

4. Be sure to use `bin/command` for anything that is under Bundler's control. Examples include `bin/rake` or `bin/rails`.


Configure Rails Application
---------------------------

1. Install Rails

    % RBENV_VERSION=1.9.2-p290 rbenv exec gem install rails

2. Create Rails app

    % RBENV_VERSION=1.9.2-p290 rbenv exec rails new my_project

2. Set rbenv version and run local bundle install

    % cd my_project
    % rbenv local 1.9.2-p290
    % bundle install --path vendor/bundle
    % bundle install --binstubs
    % echo "vendor/bundle/ruby\n" >> .gitignore
    % git init .
    % git add .
    % git commit -m "Initial commit"

1. Install pow. It is installed in `~/Library/Application Support/pow`.

    % curl get.pow.cx | sh




2. If you decide you would like to uninstall Pow, use the following command:

    % curl get.pow.cx/uninstall.sh | sh





[rails]: http://rubyonrails.org/
[ruby]: http://rubylang.org/
[37signals_setup]: http://37signals.com/svn/posts/2998-setting-up-a-new-machine-for-ruby-development
[rbenv]: https://github.com/sstephenson/rbenv
[ruby-build]: https://github.com/sstephenson/ruby-build
[rbenv-install]: https://gist.github.com/1120938
[homebrew]: http://???
