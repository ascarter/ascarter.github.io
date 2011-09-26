---
layout: post
title: Modern Ruby Development
date: '2011-09-25 19:09:01'
---

[Rails][rails] and [Ruby][ruby] have changed dramatically over the years. For those of us that have been building software on Ruby and Rails for some time, our development stack is likely due for an upgrade. Recently two things led me to review how I build Rails apps. First, I have a new project I intend to build with Rails 3.1. The other event was the release of [rbenv][rbenv] as an alternative to [RVM][rvm].

The following is a walkthrough of how I configure my Mac OS X machines for Ruby and Rails development. It is very similar to the configuration that 37signals [recently described][37signals_setup].


Pre-requisites
==============

I'm assuming you are using Mac OS X 10.7 Lion. Most of it will likely work fine under Linux (particularly Ubuntu). I have no idea nor do I care if it works on Windows. If you are using Windows for your Rails development, I think you are at a severe disadvantage. That's just reality.


Development Software Stack
==========================

The developer software stack is the toolset that allows you to efficiently create Ruby and Rails applications. For most Ruby developers, the key tools are a terminal shell, programmer's text editor, and web browser.


Xcode 4
-------

On Mac OS X, you need [Xcode 4][xcode4]. Besides the Xcode IDE, it includes the compilers and libraries you will need to build software from source. It also includes developer tools like Git.

Lion is transitioning to LLVM as the default compiler. Xcode also includes the legacy GCC compiler suite. There is an alternate community GCC only install but I don't feel it is worth the trouble. As of Mac OS X Lion, Xcode 4 is now installed via the Mac App Store.


zsh
---

Mac OS X defaults the terminal shell to [bash][bash]. It also ships with a relatively up-to-date alternative called [zsh][zsh]. I recommend learning and using zsh. It has no disadvantages compared with bash and supports numerous programmer friendly features.

If you want to set your login shell to zsh, go to **System Preferences -> Users and Groups**. Right-click on your user account and select **Advanced Options**. Change the login shell dropdown to `/bin/zsh`.


Homebrew
--------

A huge flaw of Mac OS X is the lack of a proper package manager. No mainstream Linux distribution is without a system to manage adding open source software. Given the lack of an official option from Apple, there are several community projects. The best is [Homebrew][homebrew]. The default Ruby on Rails stack does not require any packages from Homebrew. However, it is highly likely you will soon encounter a dependency that requires a library (like ImageMagick). It is recommended that you install Homebrew on your development machine. I previously wrote about [homebrew][ascarter_homebrew].


rbenv / ruby-build
------------------

Mac OS X by default ships with `Ruby 1.8.7p249`. It ships with Rubygems itself installed but no gems are installed by default. It is best to completely ignore the system Ruby for purposes of software development. The default `Ruby 1.8.7` install is useful for writing general purpose scripts. Installing gems to the system Ruby will eventually lead to a mess.

The Ruby interpreter is updated relatively frequently (at least much faster than Mac OS X). For the most part, `Ruby 1.9.2` has become the default MRI version. The acceptance of `Ruby 1.9.3` will likely also be relatively fast. There are various alternative Ruby implementations as well like [REE][ree] and [JRuby][jruby]. Most Ruby interpreters can be downloaded as source code and compiled easily. However, it is still convenient to use a tool to manage Ruby installs.

Until recently, [RVM][rvm] was the best choice. It certainly helped with managing multiple versions of Ruby but it is a mess of bash scripts that are far more invasive than I care for. Fortunately, Sam Stephenson's [rbenv][rbenv] and [ruby-build][ruby-build] offer a much more elegant and efficient way to manage your Ruby installs.

rbenv is a very young project. I've been using it for over a month now and find it much more to my liking. Additionally, I did not appreciate the reaction of RVM's author Wayne Seguin. To me, when you build open source software, you should expect (and hope) that something better comes along to replace your software. I have no interest in supporting projects that are just as much about stroking the author's ego as getting things done. Sam Stephenson has proven with [Prototype.js][prototypejs] that he is a pragmatic developer that is open to alternatives. That is an attitude I can get on board with.

rbenv uses a very safe approach. The version of Ruby that will get used is dependent on the path and some environment variables. rbenv uses wrapper scripts (shims) that at runtime adjust the paths and environment variables depending on the version of ruby requested.

I built a system similar to this several years ago. So I trust the approach. The advantage of rbenv is that it has smart wrappers to make it trivial to switch from one version of Ruby to another.

rbenv itself does not install Ruby. It just switches between installed versions. You can either build Ruby from source yourself or use the sister project [ruby-build][ruby-build] to assist you in building a Ruby install. Most mainstream Ruby versions are easily installed. The ruby-build tool will download the source, build it, and install a base version of Rubygems for that Ruby version.


Bundler
-------

Gem management has been a source of frustration to Ruby programmers for years. There have been several previous attempts at managing gems in the context of an application. The latest is [Bundler][bundler]. For the most part, it is a good way to package and manage dependencies for your application. Unlike RVM, rbenv expects Bundler to be the preferred way for managing your gems. RVM had a somewhat conflicting concept called gemsets. For better or worse, I think the approach rbenv uses by using Bundler only at least makes gem management consistent.


Pow
---

[Pow][pow] is an incredibly simple Rack server specifically for Mac OS X. It is built using [Node.js][nodejs]. It provides both an HTTP and a DNS server. It utilizes a special top-level domain (`.dev`) so you can host your apps at `http://myapp.dev/`. This is very powerful for building services that would expect to be on their own endpoints in production. Plus, it is ridiculously easy to add a new app.


Capistrano
----------

[Capistrano][capistrano] is still the best method in my opinion to deploy an application. This is separate from provisioning. It is the software to push your latest code to target servers and do any associated tasks with it. I won't talk about Capistrano much here since this article is about configuring a development machine. But Capistrano should likely be in the tool chain if you ever expect to deploy from your development environment.

Rails
-----

It goes without saying, [Rails][rails] is the main attraction. You will likely install multiple versions of Rails in each of your Ruby environments. Rails has strong support for selecting which Rails version and can be packaged via Bundler.

Git
---

For version control in the Ruby world, [Git][git] is the best choice. The majority of open source code you will interact with in the Ruby community is in Git with most projects hosted on [GitHub][github].

Editor
------

This is a very personal choice and I won't spend much on it here. I've used TextMate and MacVim in the past for Rails development. My current choice is [BBEdit 10][bbedit] from BareBones. Ideally, your editor can easily find files by name, support a project view, and have solid Ruby syntax highlighting. In nearly 5 years of Ruby development, I've never wanted to use an IDE. You'll be fine without it.


Walkthrough
===========

Given the above stack, here is a guided walkthrough of how to configure your machine. Ideally, get your computer into a clean configuration state. If you have experimented with tools like [RVM][rvm], make sure you clean up. The best case is a clean install of Mac OS X Lion with Xcode 4.

If you have previously installed RVM, remove all traces by issuing the following command:

    % rvm implode


Ruby Environment
----------------

* Install Xcode 4 from Mac App Store


* Clone rbenv

        git clone git://github.com/sstephenson/rbenv.git ~/.rbenv  
    
* Add rbenv and shims to `PATH` and enable autocompletion

        # Add following lines to .zshrc for zsh
        export PATH="$HOME/.rbenv/bin:$PATH"
        eval "$(rbenv init -)"

* Restart your shell. rbenv should now be available.

* Clone and install ruby-build

        % git clone git://github.com/sstephenson/ruby-build.git
        % cd ruby-build
        % sudo ./install.sh

* The ruby-build tool is installed to `/usr/local`. A new `rbenv install` command is available to install ruby builds to rbenv

* List available versions of Ruby

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

* Install a Ruby version

        % rbenv install 1.9.2-p290

* Rebuild rbenv shim binaries. This must be done every time a new Ruby is installed. Also run if gems that have binaries are installed.

        % rbenv rehash

* Set global Ruby if you want to use something other than the system Ruby as the default

        % rbenv global 1.9.2-p290
    
* Set local Ruby for a project. This will write the version to `.rbenv-version` in the current directory. You can safely add `.rbenv-version` to source control if all your developers are using rbenv.

        % cd my_project
        % rbenv local 1.9.2-p290
        % cat .rbenv-version
        1.9.2-p290

* Update rubygems and default gems

        # Assumes that you are running under the Ruby version you want to update
        % gem update --system
        % gem update

* Install bundler

        % gem install bundler
    

Configure a Ruby Application
----------------------------

* Create a Gemfile at root of your project

        source "http://rubygems.org"
        gem "jekyll"

* Install gems via bundler to a local `vendor` directory. Create binary stubs so you can use `bin/command` instead of `bundle exec`.

        % bundle install --path vendor/bundle
        % bundle install --binstubs

* Configure source control for bundler

        % echo ".bundle\nvendor/bundle/ruby\n" >> .gitignore
        % git add Gemfile Gemfile.lock

* Be sure to use `bin/command` for anything that is under Bundler's control. Examples include `bin/rake` or `bin/rails`.


Configure Rails Application
---------------------------

* Install Rails

        % RBENV_VERSION=1.9.2-p290 rbenv exec gem install rails

* Create Rails app

        % RBENV_VERSION=1.9.2-p290 rbenv exec rails new my_project

* Set rbenv version and run local bundle install

        % cd my_project
        % rbenv local 1.9.2-p290
        % bundle install --path vendor/bundle
        % bundle install --binstubs
        % echo "vendor/bundle/ruby\n" >> .gitignore
        % git init .
        % git add .
        % git commit -m "Initial commit"

* Install pow. It is installed in `~/Library/Application Support/pow`.

        % curl get.pow.cx | sh

* Configure pow to work with rbenv. **WARNING** - Use full path - don't use `~/myapp`. Pow will fail!

        % echo 'export PATH="/Users/andrew/.rbenv/shims:/Users/andrew/.rbenv/bin:$PATH"' > ~/.powconfig


* Add your app under pow by simply creating a symlink

        % ln -s /path/to/myapp ~/.pow/myapp

* Your Rails app should now be available under `http://myapp.dev`


Summary
=======

This should get you up and running. The combination of rbenv and ruby-build give you a huge amount of flexibility for easily creating sandbox environments for your applications.


[37signals_setup]: http://37signals.com/svn/posts/2998-setting-up-a-new-machine-for-ruby-development
[ascarter_homebrew]: /2010/02/22/homebrew-for-os-x.html
[bash]: http://www.gnu.org/s/bash/
[bbedit]: http://barebones.com/products/bbedit/
[bundler]: http://gembundler.com
[capistrano]: http://capify.org
[git]: http://git-scm.com
[github]: http://github.com
[homebrew]: http://mxcl.github.com/homebrew/
[jruby]: http://jruby.org
[nodejs]: http://nodejs.org/
[pow]: http://pow.cx
[prototypejs]: http://www.prototypejs.org/
[rails]: http://rubyonrails.org/
[rbenv-install]: https://gist.github.com/1120938
[rbenv]: https://github.com/sstephenson/rbenv
[ree]: http://www.rubyenterpriseedition.com/
[ruby-build]: https://github.com/sstephenson/ruby-build
[ruby]: http://ruby-lang.org/
[rvm]: http://beginrescueend.com/
[xcode4]: http://itunes.apple.com/us/app/xcode/id448457090?mt=12
[zsh]: http://www.zsh.org
