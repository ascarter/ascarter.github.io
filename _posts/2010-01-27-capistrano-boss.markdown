--- 
layout: post
title: Capistrano Boss
date: 2010-01-27 22:51:00
---

[Capistrano](http://capify.org) is a very useful deployment management tool widely used for Ruby on Rails production managment. I've used it for over 2 years to manage multiple environments including production, staging, and testing. It is easy to get started with and also easy to extend.

It's a tool that is so flexible that the initial reaction is to write a task for everything. The running joke on my team has been that for every question "can I ...?", the answer is "there's a task for that." Many times, it was true. Recently, we moved our application from Mongrel to Passenger. I took the opportunity to re-evaluate what tasks we needed. I eliminated all the dangerous stuff (like directly touching the database or loading up script/console via cap). I then extracted the most useful tasks.

Originally, the extensions were implemented in the `lib` folder or in a deployment plugin. Since plugins are not the way to go anymore for Rails, I decided to turn all of that into a gem. Using the fantastic new [Gemcutter](http://gemcutter.org) tool, I created [Capistrano-boss](http://github.com/ascarter/capistrano-boss).

There are recipes split up in four namespaces: deploy, apache, passenger, and rails. Most are simple but there are a couple that I find very useful. First, apache and rails both support downloading logs (**log:fetch**) and watching logs in real time (**log:watch**). The realtime log feature is one we use very frequently. I can't even remember where I found the tip originally but it does a `tail -f` and marks up the stream with the host and timestamp. It makes it very easy to watch activity on all your servers at once. On a busy server, it can get overwhelming. I intend to put in some filter options for this task at some point.

The other useful recipes are for managing the `database.yml` file. The recipe **rails:config:database** creates a configuration in `#{shared_path}/config/database.yml`. It will prompt for the database password and write it out. This allows you to checkin a clean database.yml without a password into source control. You can easily set it just once in the shared configuation location. When **deploy** is run, the recipe **rails:deploy:config** will symlink `#{shared_path}/config/database.yml` to `#{current_path}/config/database.yml`.

One other addition is an extension to the way the Subversion repository is determined. The readme explains it but the idea is that you can set `:branch` or `:tag` and have the repository path adjusted. We used it to set which tag to deploy on the cap command line:

    cap deploy -s tag='myrelease'

It assumes the standard subversion layout (branches/tags/trunk) and defaults to using trunk. As of this week though, we have moved to a pure git source control system and (thankfully) will no longer need the subversion support.

I'm hoping people will fork and submit back their favorite deployment related recipes. My goal is for light weight tasks, not full on configuration management. I headed down that path and it wasn't good. Puppet or Chef is probably a beter solution for that. But many Rails applications don't need much configuration help and that's what I want in capistrano-boss. The source is on [Github](http://github.com/ascarter/capistrano-boss) and the gem is published on [Gemcutter](http://gemcutter.org/gems/capistrano-boss).

