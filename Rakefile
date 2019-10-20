task :default => :server

desc 'Create new post with rake "post[post-name]"'
task :post, [:title] do |t, args|
  if args.title then
    new_post(args.title)
  else
    puts 'rake "post[post-name]"'
  end
end

desc 'Build site with Jekyll'
task :generate => [:clean, :scss] do
  `jekyll`
end

desc 'Generate css'
task :scss do
  `scss media/css/style.scss media/css/style.css`
end

desc 'Start server'
task :server => [:clean, :scss] do
  `jekyll serve --trace`
end

desc 'Deploy with rake "depoly[comment]"'
task :deploy, [:comment] do |t, args|
  if args.comment then
    `git commit . -m '#{args.comment}' && git push origin master && git push origin master:jekyll`
  else
    `git commit . -m 'new deployment' && git push origin master && git push origin master:jekyll`
  end
end

desc 'Clean up'
task :clean do
  `rm -rf _site`
end

desc 'Push to repo'
task :push do
  `git push origin master && git push origin master:jekyll`
end

def new_post(title)
  time = Time.now
  filename = "_posts/" + time.strftime("%Y-%m-%d-") + title + '.markdown'
  if File.exists? filename then
    puts "Post already exists: #{filename}"
    return
  end
  uuid = `uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n"`
  File.open(filename, "wb") do |f|
    f << <<-EOS
---
title: #{title}
layout: post
guid: urn:uuid:#{uuid}
tags:
  - 
---


EOS
  %x[echo "#{filename}" | pbcopy]
  end
  puts "created #{filename}"
  `git add #{filename}`
end
