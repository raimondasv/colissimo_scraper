require 'nokogiri'

module ColissimoScraper

  DATE_FIELD_URL = 'date'
  SITE_FIELD_URL = 'site'
  DESCR_FIELD_URL = 'libe'

  class PageParser

    def initialize(body)
      @html = Nokogiri::HTML(body)
    end

    def fetch_images
      @images = []

      node = @html.xpath("//div[@id='resultatSuivreDiv']/table/tbody")
      if node
        node.xpath('tr/td/img').each do |img_tag|
          src = img_tag['src']

          if /\Aimageio?/ =~ src
            if /\A(?:.*)_(?<type>date|site|libe)_(?<idx>\d+)\z/ =~ src
              @images << { src: src, field: type, index: idx.to_i  }
            end
          end
        end
      end
      @images.sort! { |a, b| a[:index] <=> b[:index] }
    end

    def contains_statuses?
      error_text.empty?
    end

    private

    def error_text
      @html.xpath("//div[@id='resultatSuivreDiv']/div[@class='error']/text()").text
    end
  end
end
