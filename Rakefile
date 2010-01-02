require 'rake'
require 'fileutils'

ROOT_DIR = File.dirname(__FILE__)
SITE_DIR = File.join(ROOT_DIR, '_site')
DRAFTS_DIR = File.join(ROOT_DIR, '_drafts')
POSTS_DIR = File.join(ROOT_DIR, '_posts')
SERVER_PORT = 4000

PUBLISH_HOST = "berlin.joyent.us"
PUBLISH_PATH = "/users/home/andrewc/web/public"

def categories(tags)
  categories = "categories:\n"
  if tags
    tags.split(%r{[\/\s]}).each { |t| categories << "- #{t.strip}\n" }
  end
  categories
end

desc "Clear generated site."
task :clean do
  rm_rf Dir.glob(File.join(SITE_DIR, '*'))
end

desc "Generate site."
task :build do
  sh "jekyll"
end

desc "Run local jekyll server"
task :server do
  sh "jekyll --server #{SERVER_PORT} --auto"
end


desc "Publish site."
task :publish => [ :build ] do |t|
  sh "rsync -avz --delete #{SITE_DIR}/ #{PUBLISH_HOST}:#{PUBLISH_PATH}"
end

desc "Create new post. Arguments: [Title, Tags]. Separate tags with space or /"
task :post, [:title, :tags] do |t, args|
  unless args.title
    puts "Usage: rake post[\"Title\", \"Tags\"]"
    exit(-1)
  end

  # TODO: Prompt for title and tags
  # Too messy on command line
  
  date_prefix = Time.now.strftime("%Y-%m-%d")
  postname = args.title.strip.downcase.gsub(/ /, '-')
  post = File.join(DRAFTS_DIR, "#{date_prefix}-#{postname}.markdown")
 
  header = <<-END
---
layout: post
title: "#{args.title}"
END

  header << categories(args.tags)
  header << <<-END
---

new post

END
 
  File.open(post, 'w') {|f| f << header }
  system("mate", "-a", post)
  puts "Created post #{post}"
end
