---
layout: post
title: Modern Ruby Development
---

[37signals on Setting Up a New Development Machine][37signals_setup]

The stack:
* zsh
* homebrew
* [rbenv]
* [ruby-build]
* bundler
* pow


rbenv
=====

ruby-build
==========

Bundler
=======

Pow
===


Setup Ruby Environment
======================

1. Checkout rbenv

    git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
    
2. Add rbenv and shims to your PATH and enable autocompletion

    # Add following lines to .bashrc for bash or .zshrc for zsh
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

3. Restart your shell. You can now begin using rbenv.

4. Clone and install ruby-build

    % git clone git://github.com/sstephenson/ruby-build.git
    % cd ruby-build
    % sudo ./install.sh

5. The ruby-build tool is now installed to `/usr/local`.

6. List available versions of Ruby

    % ruby-build --definitions
    1.8.7-p352
    1.9.2-p290
    1.9.3-preview1
    jruby-1.6.3
    rbx-1.2.4
    ree-1.8.7-2011.03
    
7. Install a Ruby version

    % ruby-build 1.9.2-p290 ~/.rbenv/versions/1.9.2-p290

8. Rebuild rbenv shim binaries. This must be done every time a new Ruby is built.

    % rbenv rehash

9. Set global Ruby

10. Set local Ruby for a project




[37signals_setup]: http://37signals.com/svn/posts/2998-setting-up-a-new-machine-for-ruby-development
[rbenv]: https://github.com/sstephenson/rbenv
[ruby-build]: https://github.com/sstephenson/ruby-build
