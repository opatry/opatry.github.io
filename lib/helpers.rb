# frozen_string_literal: true

use_helper Nanoc::Helpers::Rendering
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Blogging

require 'unicode/emoji'

def get_pretty_date(note, short: false)
  # January 5, 2021 or Jan 5, 2021
  month_format = short ? '%b' : '%B'
  attribute_to_time(note[:created_at]).strftime("#{month_format} %-d, %Y")
end

def get_rss_date(note)
  # Fri, 25 May 2012 14:48:00 +0200
  attribute_to_time(note[:created_at]).strftime('%a, %d %b %Y %H:%M:%S %z')
end

def get_xml_schema_date(note)
  note[:created_at].iso8601
end

# wrap emojis with an HTML span contained in given content
def e(content, params = {})
  clazz = params.fetch(:class, 'emoji')
  content.gsub(Unicode::Emoji::REGEX, '<span class="' + clazz + '">\0</span>')
end

module NotesHelper
  def all_notes
    @items.select { |item| item[:kind] == 'note' }
  end

  def notes
    reverse_notes.reverse
  end

  def reverse_notes
    all_notes.sort_by { |note| attribute_to_time(note[:created_at]) }
  end
end

include NotesHelper

def previous_link(item)
  notes_ = notes
  prev_article = notes_[notes_.index(item) + 1]
  if prev_article.nil?
    '<span class="disabled">&#9667;&nbsp;</span>'
  else
    title = prev_article[:title]
    html = "&#9666;&nbsp;#{title}"
    link_to(html, prev_article.reps[:default], class: 'prev', title: title)
  end
end

def next_link(item)
  notes_ = notes
  idx = notes_.index(item) - 1
  if idx.negative?
    '<span class="disabled">&nbsp;&#9657;</span>'
  else
    next_article = notes_[idx]
    title = next_article[:title]
    html = "#{title}&nbsp;&#9656;"
    link_to(html, next_article.reps[:default], class: 'next', title: title)
  end
end

def link_to_item(title, identifier)
  link_to(title, @items[identifier].path)
end

def svg_markup(item)
  item.compiled_content.dup.delete!("\n")
end

def svg_icon(item, size)
  "<span class=\"svg_icon\" style=\"width: #{size}px; height: #{size}px\">#{svg_markup(item)}</span>"
end

def project_card(slug, name, subtitle)
  project_config = @config[:projects][slug.to_sym]
  project_item = @items[project_config[:page_identifier]]
  project_illustration = @items[project_config[:illustration_identifier]]
  %{
<div class="project-card">
  <div class="project-card-content">
    <a class="project-card-image" href="#{project_item.path}"><img src="#{project_illustration.path}" alt=""></a>
    <div class="project-card-info">
      <div class="project-card-info-wrap">
        <h3 class="project-card-title">#{name}</h3>
      </div>
      <div class="project-card-info-wrap">
        <div class="project-card-subtitle">#{subtitle}</div>
      </div>
    </div>
  </div>
</div>
}
end

def project_card_illustration(slug)
  project_config = @config[:projects][slug.to_sym]
  project_illustration = @items[project_config[:illustration_identifier]]
  %{
<div class="project-card centered-media">
  <div class="project-card-content">
    <img src="#{project_illustration.path}" alt="">
  </div>
</div>
}
end