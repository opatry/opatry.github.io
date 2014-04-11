# source: http://jakoblaegdsmand.com/blog/2013/01/easy-blogging-with-nanoc/

usage       'newnote [options]'
aliases     :n, :note
summary     'Creates a new note'
description 'This command creates a new note with right date and kind.'

flag   :h, :help,  'show help for this command' do |value, cmd|
  puts cmd.help
  exit 0
end
option :t, :title,        'define the post title', :argument => :optional

run do |opts, args, cmd|
  require 'stringex'
  title = opts[:title] || 'Default Title'
  timestamp = Time.now
  
  dir = './content/notes'
  FileUtils.mkdir_p dir
  filename = "#{dir}/#{timestamp.strftime('%Y-%m-%d')}-#{title.to_url}.md"


  # FIXME make ask works
  # if File.exist?(filename)
  #   abort('newpost aborted!') if ask("#{filename} already exists. Want to overwrite?", ['y','n']) == 'n'
  # end

  puts "Creating new post: #{filename}"
  open(filename, 'w') do |post|
    post.puts '---'
    post.puts "title: #{title}"
    post.puts 'kind: note'
    post.puts "created_at: #{timestamp}"
    post.puts "---\n\n"
  end
end