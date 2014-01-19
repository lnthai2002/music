#require 'activerecord-tableless'
module Music
  class WriteTask < ActiveRecord::Base
    has_no_table

    has_many :articles
    column 'host', :string   #need at least 1 fucking column otherwise error out 
    column 'security_key', :string

    accepts_nested_attributes_for :articles

    def convert_to_hash(article_list)
      list = []
      article_list.each do |a|
        list << a.attributes.to_hash
      end
      return list
    end

    def execute
      if self.valid?
        tag_writer = DRbObject.new(nil, "druby://#{host}:54323") #RFM::Handler::TagWriter
        begin
          return tag_writer.write_mp3(convert_to_hash(articles.to_a))
        rescue DRb::DRbConnError => e
          errors.add('host', 'is not reachable')
          return []
        rescue ArgumentError => e
          errors.add('folder', e.message)
          return []
        else
          errors.add_to_base(e.message)
          return []
        end
      else
        return []
      end
    end
  end
end