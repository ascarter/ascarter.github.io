# Rakefile for Jekyll site management

require "bundler/setup"
require "jekyll"

Jekyll::PluginManager.require_from_bundler

task default: :build

desc "Initialize the environment with dependencies"
task :init do
  sh "rbenv install -s"
  sh "bundle config set --local default_install_uses_path true"
  sh "bundle config set --local disable_shared_gems true"
  sh "bundle install"
end

desc "Build the Jekyll site"
task :build do
  Jekyll::Commands::Build.process({profile: true})
end

desc "Run the Jekyll server locally"
task :serve do
  Jekyll::Commands::Serve.process({livereload: true, profile: true})
end

desc "Clean the Jekyll site"
task :clean do
  Jekyll::Commands::Clean.process({})
end

desc "Check the Jekyll site for issues"
task :check do
  Jekyll::Commands::Doctor.process({})
end
