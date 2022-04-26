class FencedCodeBlock < Nanoc::Filter
  identifier :fenced_code_block

  require 'htmlentities'

  def run(content, _ = {})
    content.gsub(/(^`{3}\s*(\S*)\s*$([^`]*)^`{3}\s*$)+?/m) do |_|
      lang_spec = Regexp.last_match(2)
      code_block = Regexp.last_match(3)

      replacement = '<div class="code-container">'

      data_lang_attr = "data-langspec=\"#{lang_spec}\"" unless lang_spec&.empty?

      language_class = lang_spec&.empty? ? 'language' : "language-#{lang_spec}"
      replacement << "<pre #{data_lang_attr} class=\"highlight\"><code class=\"#{language_class}\">"

      code_block.gsub!('[:backtick:]', '`')

      coder = HTMLEntities.new
      replacement << coder.encode(code_block)
      replacement << '</code></pre></div>'
    end
  end
end
