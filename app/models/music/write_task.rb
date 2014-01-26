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
        remoteFS = DRbObject.new(nil, "druby://#{drb_server.host}:54321") #RFM::Public::FileSystem
        begin
          return remoteFS.write_mp3_tags(select_for_saving(articles.to_a), drb_server.security_key)
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

    def select_for_saving(articles)
      articles.keep_if{|article|
        article.to_save == true
      }
      return convert_to_hash(articles)
    end

    def convert_to_hash(article_list)
      list = Hash.new
      article_list.each do |a|
        list[a.file] = a.attributes.to_hash #TODO: exclude 'file' from this hash
      end
      return list
    end
  end
end