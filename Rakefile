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

desc "Create a new draft post"
task :draft, [:title] do |t, args|
  unless args.title
    # Prompt for a post tile
  end
  
  # Create a new file with a basic template
  postname = args.title.strip.downcase.gsub(/ /, '-')
  post = File.join(DRAFTS_DIR, "#{postname}.markdown")

  header = <<-END
---
layout: post
title: #{args.title}
---

New draft post

END

  # Write draft post file
  File.open(post, 'w') {|f| f << header }
  system("mate", "-a", post)
  puts "Created draft post #{post}."
  puts "To publish, use:"
  puts "  rake post [#{postname}]"
end

desc "Publish draft post. Arguments: [title]"
task :post, [:title] do |t, args|
  require 'time'
  
  unless args.title
    puts "Usage: rake post[\"Title\"]"
    exit(-1)
  end

  published_timestamp = Time.now
  date_prefix = published_timestamp.strftime("%Y-%m-%d")
  draft_path = File.join(DRAFTS_DIR, "#{args.title}.markdown")
  draft = IO.readlines(draft_path)
  
  # Verify YAML front matter header
  unless draft[0] = "---"
    puts "ERROR: Invalid post file."
    exit(-1)
  end
  
  # Parse draft
  end_of_header = draft[1,draft.length].index("---\n") + 1
  header = YAML.load(draft[1,end_of_header].to_s)
  body = draft[end_of_header + 1, draft.length]
  
  # Create the post file
  postname = header["title"].strip.downcase.gsub(/ /, '-')
  post_path = File.join(POSTS_DIR, "#{date_prefix}-#{postname}.markdown")
  post = File.open(post_path, 'w')
  post << YAML::dump(header)
  unless header.include?("published")
    post << "published: #{Time.now.xmlschema}\n"
  end
  post << "---\n"
  post << body
  post.close
  
  # Clear draft
  File.delete(draft_path)
 
  puts "Published post:\n  #{post_path}"
end
