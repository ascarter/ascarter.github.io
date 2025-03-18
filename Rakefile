# Rakefile for Jekyll site management

require "bundler/setup"
require "standard/rake"
require "jekyll"

Jekyll::PluginManager.require_from_bundler

task default: :build

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

desc "Create a new post"
task :post, :name do |t, args|
  args.with_defaults(name: "untitled-post")
  Jekyll::Commands::Post.process([args.name], {})
end

desc "Create a new draft"
task :draft, :name do |t, args|
  args.with_defaults(name: "untitled-draft")
  Jekyll::Commands::Draft.process([args.name], {})
end

desc "Create a new page"
task :page, :name do |t, args|
  args.with_defaults(name: "untitled-page")
  puts "Creating page #{args.name}"
  Jekyll::Commands::Page.process([args.name], {})
end

desc "Publish a draft"
task :publish, :draft do |t, args|
  abort "Please provide a draft name" if args[:draft].nil? || args[:draft].empty?

  # Check if draft exists (with or without md extension)
  draft_path = File.join("_drafts", args[:draft])
  draft_path = (File.extname(draft_path) == ".md") ? draft_path : "#{draft_path}.md"

  abort "Draft not found" unless File.exist?(draft_path)
  Jekyll::Commands::Publish.process([draft_path], {})
end
