include Nanoc::Helpers::Rendering
include Nanoc::Helpers::LinkTo
include Nanoc::Helpers::Blogging

def get_pretty_date(note)
  # dimanche 9 mars 2014, 17h40
  attribute_to_time(note[:created_at]).strftime('%A %-d %B %Y, %kh%M')
end

def get_rss_date(note)
  # Fri, 25 May 2012 14:48:00 +0200
  attribute_to_time(note[:created_at]).strftime('%a, %d %b %Y %H:%M:%S %z')
end

def get_xml_schema_date(note)
  note[:created_at].to_iso8601_date
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

# from https://ecarmi.org/writing/next-previous-links-nanoc/
def previous_link
  notes_ = notes
  prev_article = notes_[notes_.index(@item) + 1]
  if prev_article.nil?
    '<span class="disabled">&#9667;&nbsp;</span>'
  else
    title = prev_article[:title]
    html = "&#9666;&nbsp;#{title}"
    link_to(html, prev_article.reps[0], :class => "prev", :title => title)
  end
end

def next_link
  notes_ = notes
  idx = notes_.index(@item) - 1
  if idx < 0
    '<span class="disabled">&nbsp;&#9657;</span>'
  else
    next_article = notes_[idx]
    title = next_article[:title]
    html = "#{title}&nbsp;&#9656;"
    link_to(html, next_article.reps[0], :class => "next", :title => title)
  end
end

def link_to_item(title, identifier)
  item = @items.find { |i| i.identifier == identifier }
  link_to(title, item.path)
end
