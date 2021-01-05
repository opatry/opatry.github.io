# frozen_string_literal: true

source 'https://rubygems.org'

# nanoc itself
gem 'nanoc', '~> 4.0'

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
gem 'nokogiri'

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

gem 'sass'

group 'development' do
  gem 'debase', require: false
  gem 'ruby-debug-ide', require: false
  gem 'solargraph', require: false
end
