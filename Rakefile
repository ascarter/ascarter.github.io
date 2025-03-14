# Rakefile for Jekyll site management

task :default => :build

desc "Initialize the environment with dependencies"
task :init do
  puts "Initializing environment..."
  sh "rbenv install -s"
  sh "bundle config set --local default_install_uses_path true"
  sh "bundle config set --local disable_shared_gems true"
  sh "bundle install"
  puts "Environment initialized."
end

desc "Build the Jekyll site"
task :build do
  puts "Building site..."
  sh "bundle exec jekyll build"
  puts "Site built."
end

desc "Run the Jekyll server locally"
task :serve do
  puts "Starting Jekyll server..."
  sh "bundle exec jekyll serve"
end

desc "Clean the Jekyll site"
task :clean do
  puts "Cleaning site..."
  sh "bundle exec jekyll clean"
  puts "Site cleaned."
end

desc "Check the Jekyll site for issues"
task :check do
  puts "Checking site..."
  sh "bundle exec jekyll doctor"
  puts "Check completed."
end
