require 'rake'
require 'fileutils'

SITE_DIR = File.join(File.dirname(__FILE__), '_site')

PUBLISH_HOST = "berlin.joyent.us"
PUBLISH_PATH = "/users/home/andrewc/web/public/reboot"

desc "Clear generated site"
task :clean do
  rm_rf Dir.glob(File.join(SITE_DIR, '*'))
end

desc "Generate site"
task :build do
  sh "jekyll"
end

desc "Publish site"
task :publish => [ :build ] do |t|
  sh "rsync -avz --delete #{SITE_DIR}/ #{PUBLISH_HOST}:#{PUBLISH_PATH}"
end
