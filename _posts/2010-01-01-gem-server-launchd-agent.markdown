---
layout: post
title: Gem Server launchd Agent
date: 2010-01-01 14:05:00
---

[Ruby Gems](http://rubyforge.org/projects/rubygems/) provides an [RDoc](http://rdoc.sourceforge.net) server for the installed gems on a system. It is trivial to get it up and running. In your console, use the following command:

	gem server

A local http server will now be running on port 8808 that serves all the installed RDoc documentation for your gems. It's a great way to look at the exact documentation that matches the code your have installed.

Starting with Mac OS X 10.4, managing daemons and other services has been performed by [launchd](http://developer.apple.com/macosx/launchd.html). It's an elegant and modern replacement for traditional startup systems like init and rc. But it wasn't entirely obvious to me how to create my own custom startup script.

There are two places you could chose to setup your daemon. One is at the system level for any user on the machine. Another is in your local user account. If you put it at the system level (in */Library/LaunchAgents*), you will have the server up and running anytime the machine boots up. If you use your user account, it will launch on login.

On my MacBook Pro laptop, I chose to use a launch agent for my account. On a shared machine or server, you might want to use the system level approach.

To define a launch agent, create a file for the launchd definition called:

	~/Library/LaunchAgents/org.rubyforge.rubygems.server.plist

Then, use the following code to define a launchd agent that will startup the gem server instance:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>org.rubyforge.rubygems.server</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/bin/gem</string>
		<string>server</string>
		<string>--daemon</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>KeepAlive</key>
	<true/>
</dict>
</plist>
{% endhighlight %}

You can either log out then log back in or load and start it from the command line:

	launchctl load ~/Library/LaunchAgents/org.rubyforge.rubygems.server.plist
	launchctl start org.rubyforge.rubygems.server	

Enter the following in your browser:

	http://localhost:8808/

From now on when you login, you will have a running gem server with local copies of the documentation for all versions of the gems installed on your machine. 
