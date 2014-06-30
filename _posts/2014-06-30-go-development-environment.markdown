---
layout: post
title: Go Development Environment
date: '2014-06-30 10:22:40'
---

Recently, I've started to work with the [Go][1] language. One initial point of confusion for me was how to use [workspaces][2]. They work a little different than other frameworks and languages.

In simple terms, a workspace sets the context for running the go tool. Go is implemented by a suite of binaries similar to GCC. There is a compiler, linker and other tools for managing specific aspects of the Go workflow. On top of all of this is a tool called `go` that lets you use much simpler meta tasks like `build`, `install`, and `test`. For the high level tool to operate, it needs to have a context to work within. This includes where to find code and dependencies, where to build and install components, and generally set the state of the world.

Many languages have the concept of a path. Python, Ruby, and Java all operate where you set an environment variable that lets the tools resolve where to find dependencies. Go has a similar concept. There are two primary environment variables that are used by the `go` tool. `GOROOT` is typically set to the location where the go binaries and standard libraries are installed. For example, on Mac OS X, this would be `/usr/local/go`. The second variable is `GOPATH`. This represents where you would put your code and any code you have pulled in as dependencies.

The `GOPATH` variable can have as many components as you like. It could be one location or several. It is up to you. This is where workspaces come in. A go workspace is effectively a working area that is composed of the following:

    bin/
    pkg/
    src/

These three directories form the conventions that the go tool will use to find and build things. All paths are relative to the workspace root and component directory.

A more complete example would be like the following:

    bin/
      todo
    pkg/
      linux_amd64/
        code.google.com/p/goauth2
          oauth.a
        github.com/nf/todo
          task.a
    src/
      oauth/
        oauth.go
        oauth_test.go
      github.com/nf/
        todo/
          task/
            task.go
          todo.go
      ...

Go recommends using repository paths as name spacing mechanism. Even if you never check in your code, using this layout makes things easier. The `GOPATH` is simply a list of all these workspaces you might want to use.

So far so good - you have a way of collecting code and working with it. You have a mechanism for convenience tools to interact with it. You might be tempted to just make `~/Projects/my_gocode` and set that to `GOPATH` and put everything in there. That might be fine but anyone who has spent time working with code that involves external dependencies can tell you, that can get messy fast. Languages like Python and Ruby have helpers like [virtualenv][3] or [rbenv][4] for creating isolated environments. It seems like a useful idea in Go as well.

Go has a different kind of package manager. It has similarities to [PyPi][5] or [Rubygems][6] but without a strong notion of versioning. Go strongly encourages using the latest version in master. There is no general versioning support. Whether that is good or not is still being debated. The `go` tool itself has a `get` command that will fetch the head of a dependency much like a package manager would. The key thing here is that it will fetch it to the first workspace on the `GOPATH`. Alternately, you could `git checkout` any version you wanted directly into `src/` to lock to a version or control it more precisely.

With all that in mind, I wanted to give myself a little more flexibility. Conceptually putting everything in one place didn't feel right to me. I would prefer a little more flexibility and isolation. The nice thing is that `GOPATH` gives you all that power - you just need to set it.

I created a simple workspace manager tool. I found several others (even with the same name) but none did quite what I wanted. I don't want a Go version of virtualenv or rbenv. That seems heavier than what I want. All I need is a more convenient way to switch my workspace context and then use all the standard Go tools.

The tool I created is [goenv][7].

    Go workspace manager

    Usage:

      goenv command [arguments]

    The commands are:

      init     initialize path as workspace (default working directory)
      switch   switch workspace to path (default to working directory)
      add      add path to workspace (default working directory)
      rm       remove path from workspace (default working directory)
      reset    reset to workspace to empty
      list     list all workspace paths
      which    show current Go workspace
      env      environment variables for workspace

    goenv manages the workspace by setting the GOPATH environment variable
    When setting or adding a workspace, goenv will search up the path
    to find the parent with the required GOPATH entries of bin, pkg, and
    src

Let's see an example workflow.

You can create a new workspace by using `goenv init`. This will create a standard Go workspace layout (`bin/`, `pkg/`, `/src`) and add it to the `GOPATH`. The path to the workspace can be relative or absolute. The command `goenv list` shows all the active workspaces. The command `goenv env` is a short version of `go env` that is just the `GOROOT` and `GOPATH` currently set.

    % goenv init myapp
    
    % cd myapp
    
    % goenv list
    /Users/andrew/Projects/myapp

    % goenv env
    GOPATH=/Users/andrew/Projects/myapp
    GOROOT=/usr/local/go

With the `GOPATH` set, you can use standard go tool commands like `go get`. All workspaces added via `goenv` will have the `bin/` path added to the `PATH` so you can easily run any binaries you build.

    % go get code.google.com/p/go.example/hello

    % ls -l src/code.google.com/p/go.example/
    total 24
    -rw-r--r--  1 andrew  staff   1.4K Jun 30 09:36 LICENSE
    -rw-r--r--  1 andrew  staff   1.3K Jun 30 09:36 PATENTS
    -rw-r--r--  1 andrew  staff   102B Jun 30 09:36 codereview.cfg
    drwxr-xr-x  3 andrew  staff   102B Jun 30 09:36 hello/
    drwxr-xr-x  4 andrew  staff   136B Jun 30 09:36 newmath/

    % ls bin/
    hello*

    % hello
    Hello, world.  Sqrt(2) = 1.414213562373095

Adding a second workspace works like before. If it already exists, `go add` will amend it. Alternately, if you use `go switch`, it will clear any currently set workspace and set it to only the new one you added.

    % cd ..

    % goenv init myapp2

    % goenv list
    /Users/andrew/Projects/myapp
    /Users/andrew/Projects/myapp2

Removing a workspace works like add.

    % goenv rm myapp

    % goenv list
    /Users/andrew/Projects/myapp2

If you are in a working directory, you can find the implied workspace with the `goenv which` command. This will walk up the path until it finds a go workspace root and either return that path or none if it isn't in a go workspace. This is how the `go add` and `go switch` methods determine it implicitly.

    % cd myapp

    % goenv which
    /Users/andrew/Projects/myapp
    
    % cd src/code.google.com/p/go.example/hello

    % goenv switch

    % goenv list
    /Users/andrew/Projects/myapp

Also you can work with multiple paths.

    % cd ~/Projects/myapp
    
    % goenv reset

    % goenv list
    Go workspace not set

    % goenv add myapp myapp2

    % goenv list
    /Users/andrew/Projects/myapp
    /Users/andrew/Projects/myapp2

I'm finding this is about all I've needed for managing workspaces. It is convenient to set the context and use the built in tools. Additionally, it is easily transferrable to a Make file in that you simply would need to set the `GOPATH` and the rest would fall out. Like a lot of Go, the simplicity is a little misleading at first but it is elegant when you wrap your head around it.

For [BBEdit][8] users, I'm working on a [Go.bbpackage][9] that includes some similar ideas for running go commands on the current document. Since BBEdit will run each in a new shell context, the workspace is always dynamically found and used. I'm not sure yet if or how I want to bubble up some of the more complicated methods.

[1]: http://golang.org
[2]: http://tip.golang.org/doc/code.html
[3]: https://pypi.python.org/pypi/virtualenv
[4]: http://rbenv.org
[5]: http://pypi.python.org/pypi
[6]: http://rubygems.org
[7]: http://github.com/ascarter/goenv
[8]: http://barebones.com/products/bbedit/
[9]: https://github.com/ascarter/Go.bbpackage