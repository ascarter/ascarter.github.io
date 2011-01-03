--- 
layout: post
title: Rails Development on Ubuntu 10.10
date: 2011-01-02 21:28:30
---

My preferred hosting platform is [Ubuntu Linux][ubuntu]. I've posted guides for [Ubuntu 9.10][ubuntu910] and [Ubuntu 10.04][ubuntu1004] previously. Since then, I've starting using [Ruby Version Manager][rvm]. RVM has drastically changed how I provision a server. So it is time to share a new approach.

**Disclaimer:**

> This recipe is based on my own experience and preferences. You will find many other opinions. I highly recommend you study each step and understand what packages and functionality you are enabling. When it comes time to deploy to production, you want a minimal configuration. My hope is that this can help others get a sensible Rails server up and running quickly.

Assumptions
===========

The steps are done assuming a new clean install of Ubuntu 10.10 Server. It should be nearly identical on Ubuntu Desktop. I'll use `apt-*` commands so you can do everything from the command line. Use synaptic, dpkg, or any other package tool if you wish.

Pre-requisites
==============

By default, Ubuntu Server is extremely minimal. The only package I typically select in the **Software selection** page is the OpenSSH Server. Otherwise, I install everything else explicitly. I recommend using RVM to manage Ruby and gems. There are a few packages you will need to have in place before you can proceed with RVM.

Install the development package that includes GCC. You should also install [Git][git] source control tools. Even if you aren't using git for your own code, you should use it for RVM. Finally, add a few other tools that will be useful:

	sudo apt-get install build-essential git curl vim python-software-properties

Ruby Version Manager
====================

The Ruby Version Manager project has radically altered how developers manage Ruby and gems. It allows the Ruby environment to be fine tuned per application. My [previous post][rvm] explained how to setup RVM on Mac OSX for development. For an Ubuntu server, the approach is a little different. RVM has a specific install method for [system wide][rvmsys] installation. This is the recommended way to setup a dedicated Rails server.

System wide install is designed to be used by multiple applications or users. It is installed into `/usr/local/rvm`, `/usr/local/bin`, and `/etc/rvm`. It also creates an rvm group for managing permissions. In short, it is an ideal method for managing Ruby on an application server.

To install, RVM you need to be in a root shell. This command will download a bootstrap script that will do a git clone of RVM into `/usr/local/rvm`.

	sudo -s
	bash < <( curl -L http://bit.ly/rvm-install-system-wide )

The output of the script will explain what RVM has done. In particular, it will offer a recommended list of dependencies that should be installed. It will also explain how to modify the bash environment to properly load RVM.

First, install the remaining recommended dependencies. A few were already installed in previous steps. The following have not yet been installed:

{% highlight bash %}
sudo apt-get install bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev sqlite3 libsqlite3-0 libxml2-dev libxslt-dev autoconf subversion libcurl4-openssl-dev
{% endhighlight %}

Next, update the bash environment for any users that should load RVM:

	vim /home/$USER/.bashrc

Add the following to the end of the file:

{% highlight bash %}
if [ -s "/usr/local/rvm/scripts/rvm" ]; then 
        # This loads RVM into a shell session.
        source /usr/local/rvm/scripts/rvm 
fi
{% endhighlight %}

Additionally, fix up statements that embed a return statement in a bash if clause:

{% highlight bash %}
[ -z "$PS1" ] && return
{% endhighlight %}

Change these to:

{% highlight bash %}
if [[ -n "$PS1" ]] ; then
  # ... original content that was below the '&& return' line ...
fi # be sure to close the if at the end of the .bashrc.
{% endhighlight %}

In particular, edit the following:

{% highlight bash %}
6 # If not running interactively, don't do anything  
7 [ -z "$PS1" ] && return
{% endhighlight %}

Change to:

{% highlight bash %}
6 # If not running interactively, don't do anything
7 if [ -z "$PS1" ]; then
8         return
9 fi
{% endhighlight %}

Repeat for all users that will run Ruby via RVM. This includes editing the root user as well in `/root/.bashrc`. Now that the bash environment has been configured, log out and log back in. Verify RVM is correctly configured by running the following command:

	$ rvm --version
	rvm 1.1.6 by Wayne E. Seguin (wayneeseguin@gmail.com) [http://rvm.beginrescueend.com/]

Ruby and Gems
=============

With the base server provisioned, Ruby and gems can be added. RVM provides tools for easy management of multiple versions of Ruby. Gems can also be managed by RVM. However, applications should use [Bundler][bundler] to freeze gems into the source tree for deployment. You will need to have a version of Ruby installed along with a very basic set of gems. Most other gems should be packaged (even native extensions). The gem list will be very short.

For Rails 3, the current default is to use Ruby 1.9.2 MRI.  Another common choice is to use Phusion's Ruby Enterprise Edition (REE) patches. Either is a good choice for a standard Rails server. If you are integrating Java code, JRuby is a good choice. Other Ruby implementations like Rubinius are a little more experimental right now.

I prefer using Ruby 1.9.2 over the other options. Use RVM to install Ruby 1.9.2 along with the minimal default Ruby gems. Also, set Ruby 1.9.2 as the default Ruby interpreter and install the Bundler gem:

	sudo rvm install ruby-1.9.2
	sudo rvm --default use 1.9.2
	sudo -s
	rvm use 1.9.2
	gem install bundler

Verify the install of Ruby 1.9.2 by activating it:

	$ rvm use ruby-1.9.2
	$ rvm info
	
	ruby-1.9.2-p136:
	
	  system:
	    uname:       "Linux railshost 2.6.35-22-server #35-Ubuntu SMP Sat Oct 16 22:02:33 UTC 2010 x86_64 GNU/Linux"
	    bash:        "/bin/bash => GNU bash, version 4.1.5(1)-release (x86_64-pc-linux-gnu)"
	    zsh:         " => not installed"
	
	  rvm:
	    version:      "rvm 1.1.9 by Wayne E. Seguin (wayneeseguin@gmail.com) [http://rvm.beginrescueend.com/]"
	
	  ruby:
	    interpreter:  "ruby"
	    version:      "1.9.2p136"
	    date:         "2010-12-25"
	    platform:     "x86_64-linux"
	    patchlevel:   "2010-12-25 revision 30365"
	    full_version: "ruby 1.9.2p136 (2010-12-25 revision 30365) [x86_64-linux]"
	
	  homes:
	    gem:          "/usr/local/rvm/gems/ruby-1.9.2-p136"
	    ruby:         "/usr/local/rvm/rubies/ruby-1.9.2-p136"
	
	  binaries:
	    ruby:         "/usr/local/rvm/rubies/ruby-1.9.2-p136/bin/ruby"
	    irb:          "/usr/local/rvm/rubies/ruby-1.9.2-p136/bin/irb"
	    gem:          "/usr/local/rvm/rubies/ruby-1.9.2-p136/bin/gem"
	    rake:         "/usr/local/rvm/gems/ruby-1.9.2-p136/bin/rake"
	
	  environment:
	    PATH:         "/usr/local/rvm/gems/ruby-1.9.2-p136/bin:/usr/local/rvm/gems/ruby-1.9.2-p136@global/bin:/usr/local/rvm/rubies/ruby-1.9.2-p136/bin:/usr/local/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/X11R6/bin:/usr/local/rvm/bin"
	    GEM_HOME:     "/usr/local/rvm/gems/ruby-1.9.2-p136"
	    GEM_PATH:     "/usr/local/rvm/gems/ruby-1.9.2-p136:/usr/local/rvm/gems/ruby-1.9.2-p136@global"
	    MY_RUBY_HOME: "/usr/local/rvm/rubies/ruby-1.9.2-p136"
	    IRBRC:        "/usr/local/rvm/rubies/ruby-1.9.2-p136/.irbrc"
	    RUBYOPT:      ""
	    gemset:       ""
	
	
	$ ruby --version
	ruby 1.9.2p136 (2010-12-25 revision 30365) [x86_64-linux]
	
	$ gem list
	
	*** LOCAL GEMS ***
	
	rake (0.8.7)
	rubygems-update (1.4.1)
	

Ruby 1.9.2 is available and has the absolute minimal gems installed.

Nginx Web Server
================

I'm a recent convert to [nginx][nginx]. I have used [Apache][apache] exclusively for years for Rails and other web projects. Currently nginx is rapidly gaining favor in the Rails community due to the simpler configuration and strong performance. Apache is still a valid choice but you should take a hard look at nginx for Rails. [Phusion Passenger][passenger] supports both equally well. The primary difference between Apache and nginx is how requests are managed. Apache uses either a thread or process based approach. Nginx uses asynchronous events.

On Ubuntu, the version of nginx in the default repositories is somewhat dated. There is a PPA maintained by the nginx project. It is easy to add custom repositories in Ubuntu. You can either add entries directly to `/etc/apt/sources.list` or create individual list files in `/etc/apt/sources.list.d`.  The second approach seems like a cleaner method to me.

There is one other caveat. Unlike Apache, nginx does not support loadable modules. Therefore, the server must be rebuilt to add a different module. If you plan to use Passenger, skip to that section below. The Passenger installer will download and build nginx for you.

If you want to install nginx and control the modules, the following creates an apt source entry for the nginx ppa. There are three flavors of install: `nginx-light`, `nginx-extras`, and `nginx-full`. The difference is in which modules are added. You will have to judge for yourself if you need any of the extra modules. Run `apt-cache show [pkgname]` to list the modules included. For this tutorial, I'll use the light package:

	$ sudo -s
	# echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu maverick main" >> /etc/apt/sources.list.d/nginx.list
	# apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
	# apt-get install nginx-light

After install, the nginx web server should be up and running. Enter your hostname or IP address in your browser and you should see:

{% highlight html %}
<html>
<head>
<title>Welcome to nginx!</title>
</head>
<body bgcolor="white" text="black">
<center><h1>Welcome to nginx!</h1></center>
</body>
</html>
{% endhighlight %}

Passenger
=========

Besides a web server, Rails needs an applications server. [Passenger][passenger] is a good choice for most applications. It provides good performance and reliability. It is also relatively easy to use. Additionally, there is now a standalone mode for Passenger that you can use during development.

[Unicorn][unicorn] is another popular choice for resource intensive or high volume sites. Unicorn leverages the Linux kernel itself for managing workers. Unicorn is being used on some well known sites like [GitHub][github] and [Twitter][twitter]. If you are managing lots of fast clients at high bandwidth, Unicorn is likely a better choice. Unicorn is an application server. A proxy must be used to route HTTP requests.

Since this is a more general recipe, let's use Passenger. It is a module you can use with both Apache and nginx. One Ruby interpreter is used for all applications. If you need to run more than one version of Ruby, you will need to use a proxy and multiple instances of application servers.

First, install the Passenger 3 gem:

	$ sudo -s
	# gem install passenger

The next step is to build the module for the web server. If you are using nginx and are not using it for other applications, the easiest thing to do is to let Passenger download and build it for you. Pick option 1 when prompted by the installer. Pick a directory for the install. I recommend using `/opt/nginx`.

	$ sudo -s
	# passenger-install-nginx-module
	
	Automatically download and install Nginx?
	
	Enter your choice (1 or 2) or press Ctrl-C to abort: 1
	
	Where do you want to install Nginx to?
	
	Please specify a prefix directory [/opt/nginx]: /opt/nginx

The installer will create a valid configuration in `/opt/nginx/conf/nginx.conf` that references the current RVM Ruby and Gems. Next, configure nginx with a startup script:

	sudo mkdir /opt/nginx/init.d
	sudo wget --no-check-certificate http://github.com/ascarter/nginx-ubuntu-rvm/raw/master/nginx -O /opt/nginx/init.d/nginx
	sudo chmod +x /opt/nginx/init.d/nginx
	sudo ln -s /opt/nginx/init.d/nginx /etc/init.d/nginx
	sudo /etc/init.d/nginx start
	sudo /etc/init.d/nginx status
	sudo  /etc/init.d/nginx stop
	sudo /usr/sbin/update-rc.d -f nginx defaults

PostgreSQL Database Server
==========================

I prefer [PostgreSQL][postgresql] for my database server. I like the feature set and have found it reliable, robust, and high performance.

For Ubuntu 10.10, PostgreSQL 9 was released too late to make it in the official repositories. Martin Pitt manages a [PPA][pgsqlppa] that can be used to get the latest stable release. If you want to use 8.4, you can use the one included in the primary repository.

Add the PostgreSQL PPA and install PostgreSQL 9:

	sudo add-apt-repository ppa:pitti/postgresql
	sudo apt-get update
	sudo apt-get install postgresql libpq-dev

The default PostgreSQL install has one role defined for `postgres`. Ideally, you should create a role for each application to keep in order to implement least required privileges. To create a role and a database for an application, use the following commands:

	sudo -u postgres createuser -D -A -P myuser
	sudo -u postgres createdb -O myuser mydb
	sudo -u myuser psql mydb

Creating a Rails Application
============================

Let's create a quick test application that can be used to validate the server. On your development machine, set your RVM environment to Ruby 1.9.2 with the Rails 3 gems installed. Create the application:

	rails new myapp --database=postgresql
	cd myapp
	git init
	git add *
	git commit -a -m "Initial import"
	bundle install
	git add .gitignore
	git commit -a -m "Add .gitignore"

Edit the `myapp/config/database.yml` file to match the user and password. In this example, the database server is localhost. If you are using a shared database, replace as appropriate.

Packaging Gems with Bundler
===========================

The next step is to package up the gems for the application. Bundler is the preferred tool currently for packing gems into the application for deployment. Be sure to add any gems you need to the Gemfile. Once the gem file is complete, package the gems and add to the repository:

	bundle check
	bundle install
	bundle package
	git add vendor/cache
	git commit -a -m "Vendor gems"

Deploying an Application With Capistrano
========================================

[Capistrano][capistrano] is an excellent tool for deploying Ruby applications. Even if you use a provisioning tool like [Chef][chef], Capistrano is likely the solution you will use to push new versions of your application.

First, enable Capistrano in the gem file by uncommenting the gem:

{% highlight ruby %}
# Deploy with Capistrano
gem 'capistrano'
{% endhighlight %}

Next, install capistrano:

	bundle check
	bundle install
	bundle package
	git add vendor/cache
	git commit -a -m "Enable capistrano"

Capify the application. This will create a default `deploy.rb` file that will be used to configure the deployment.

	capify .

Edit the `myapp/config/deploy.rb` file to look like the following. Edit the user and paths to match your system:

{% highlight ruby %}
# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.
require "rvm/capistrano"                  

# Set RVM environment
set :rvm_ruby_string, 'ruby-1.9.2'

# Add bundler support to capistrano
require "bundler/capistrano"

set :application, "myapp"
set :repository,  "git@gitserver:myapp.git"

set :user, "myuser"
set :use_sudo, false

# Enable Git and use the master branch
set :scm, :git
set :branch, "master"

# Faster deploys via remote caching
set :deploy_via, :remote_cache

# Pick a root for applications
set :deploy_to, "/opt/mycompany/#{application}"

# Enable password prompting and ssh key forwarding
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Shorthand for a single server
# Use separate roles when multiple servers
server "railshost.local", :app, :web, :db, :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

{% endhighlight %}

For easy of deployment, I recommend adding public keys to the SSH authorized keys for the application user for all users that will perform deployments. This avoids having to share a password for the application user. Also, create a root directory to store your applications. This directory should be owned by either your application user or group writable for a user that the application user is a member of.

The final step is to test a deployment. Push your repository to a location accessible by your Rails server. Then provision the application directory and deploy:

	cap deploy:setup
	cap deploy

The app will now be in the application directory. Initialize the database if necessary. On the rails host, run the following:

	sudo -u myuser -s
	cd /opt/mycompany/myapp/current
	RAILS_ENV=production rake db:schema:load
	RAILS_ENV=production rake db:seed
	RAILS_ENV=production rake db:migrate

The final task is to configure nginx for your application. Edit `/opt/nginx/conf/nginx.conf` to add your application:

{% highlight nginx %}
   ...
   server {
        listen       80;
        server_name  localhost;
	
	...

        # My application
        root /opt/mycompany/myapp/current/public;
        passenger_enabled on;
   }
{% endhighlight %}

Restart nginx and your application should be available.

Summary
=======

Ubuntu Server provides the foundation for creating efficient Rails application hosts. RVM and bundler help separate the Ruby configuration from the base server tasks. Try creating a Rails host in a virtual machine to tune the approach to fit your own requirements.

[ubuntu]: http://ubuntu.com/
[ubuntu910]: /2010/01/04/rails-development-on-ubuntu-9.10.html
[ubuntu1004]: /2010/05/10/rails-development-on-ubuntu-10.04.html
[rvm]: /2010/05/30/ruby-version-manager.html
[git]: http://git-scm.org/
[rvmsys]: http://rvm.beginrescueend.com/deployment/system-wide/
[nginx]: http://nginx.org
[apache]: http://httpd.apache.org
[passenger]: http://www.modrails.com/
[unicorn]: http://unicorn.bogomips.org/
[github]: http://github.com
[twitter]: http://twitter.com
[postgresql]: http://postgresql.org
[pgsqlppa]: https://launchpad.net/~pitti/+archive/postgresql
[capistrano]: http://github.com/capistrano/capistrano/
[chef]: http://opscode.com/chef
[bundler]: http://gembundler.com
