# Rakefile for Jekyll site management

require "bundler/setup"
require "standard/rake"
require "tty-prompt"
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
  prompt = TTY::Prompt.new
  title = args[:name] || prompt.ask("Enter post title:", default: "Untitled")
  Jekyll::Commands::Post.process([title], {})
end

desc "Create a new draft"
task :draft, :name do |t, args|
  prompt = TTY::Prompt.new
  title = args[:name] || prompt.ask("Enter draft title:", default: "Untitled")
  Jekyll::Commands::Draft.process([title], {})
end

desc "Create a new page"
task :page, :name do |t, args|
  prompt = TTY::Prompt.new
  title = args[:name] || prompt.ask("Enter page title:", default: "Untitled")
  Jekyll::Commands::Page.process([title], {})
end

desc "Publish a draft"
task :publish, :draft do |t, args|
  prompt = TTY::Prompt.new
  draft = args[:draft]

  # Prompt to pick from list of drafts if no draft provided
  if draft.nil?
    drafts = FileList["_drafts/*.md"].map { |f| File.basename(f, ".md") }
    abort("No drafts found") if drafts.empty?
    draft = (drafts.count == 1) ? drafts.first : prompt.select("Select draft to publish:", drafts)
  end

  # Check if draft exists (with or without md extension)
  draft_path = File.join("_drafts", draft)
  draft_path = (File.extname(draft_path) == ".md") ? draft_path : "#{draft_path}.md"

  puts "Publishing draft: #{draft_path}"
  abort "Draft not found" unless File.exist?(draft_path)
  Jekyll::Commands::Publish.process([draft_path], {})
end
