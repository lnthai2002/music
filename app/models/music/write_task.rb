#require 'activerecord-tableless'
module Music
  class WriteTask < ActiveRecord::Base
    has_no_table

    column 'drb_server_id', :integer   #need at least 1 fucking column otherwise error out 

    has_many :articles
    belongs_to :drb_server

    accepts_nested_attributes_for :articles
    
    validates 'drb_server_id', presence: true

    def execute
      if self.valid?
        tag_writer = DRbObject.new(nil, "druby://#{drb_server.host}:54323") #RFM::Handler::TagWriter
        begin
          return tag_writer.write_mp3(convert_to_hash(articles.to_a), drb_server.security_key)
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

    private

    def convert_to_hash(article_list)
      list = []
      article_list.each do |a|
        list << a.attributes.to_hash
      end
      return list
    end
  end
end