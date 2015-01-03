# from gpakosz/pempek.net

require 'html_compressor'

class HtmlCompressorFilter < Nanoc::Filter
  identifier :html_compressor

  def run(content, params = {})
    case params.delete(:type)
      when 'txt'
        # do nothing
        content
      when 'xml'
        XmlCompressor.new(params).compress(content)
      else
        HtmlCompressor::HtmlCompressor.new(params).compress(content)
    end
  end
end

class XmlCompressor < HtmlCompressor::Compressor
  def self.compressor_type
    'xml'
  end
end