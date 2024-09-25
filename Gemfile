# frozen_string_literal: true

source 'https://rubygems.org'

# nanoc itself
gem 'nanoc', '>= 4.11'

# Since nanoc 4.11.21, clonefile enabled copy-on-write
# See https://github.com/nanoc/nanoc/pull/1509
# See https://github.com/nanoc/nanoc/pull/1511
gem 'clonefile'

# nanoc view
gem 'adsf'
gem 'rack'
# needed when using Ruby 3, webrick not bundled anymore with Ruby
# (see https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/)
gem 'webrick'

# nanoc validate:css and validate:html Rake tasks
gem 'w3c_validators'

# nanoc filters
gem 'kramdown' # markdown

# css
gem 'rainpress'

# relativize paths
# v1.11.0 introduces "faster and more reliable installation: Native Gems for Linux and OSX/Darwin"
# see https://github.com/sparklemotion/nokogiri/releases/tag/v1.11.0
gem 'nokogiri', '>= 1.11.0'

# javascript
gem 'uglifier'

# html
gem 'html_compressor'

# syntax highlighting
gem 'htmlentities'
gem 'rouge'
gem 'systemu'

# string utils
gem 'stringex'
gem 'unicode-emoji'

gem 'sass'

group :development do
  # debug
  #gem 'debase', require: false
  #gem 'ruby-debug-ide', require: false

  # lint
  gem 'solargraph', require: false
end
