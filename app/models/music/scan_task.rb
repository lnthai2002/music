#require 'activerecord-tableless'
module Music
  class ScanTask < ActiveRecord::Base
    has_no_table

    column 'folder', :string
    column 'recursive', :boolean
    column 'drb_server_id', :integer

    belongs_to :drb_server
    validates 'folder', 'drb_server_id', :presence=>true
    
    def execute
      if self.valid?
        tag_reader = DRbObject.new(nil, "druby://#{drb_server.host}:54322") #RFM::Handler::TagReader
        crawler = DRbObject.new(nil, "druby://#{drb_server.host}:54321") #RFM::Lib::DiskCrawler
        begin
          return wrap(crawler.scan_and_process_files(folder,
                                                     tag_reader,
                                                     recursive,
                                                     drb_server.security_key){|file|
            tag_reader.read_mp3(file, drb_server.security_key)
          })
        rescue DRb::DRbConnError => e
          errors.add(:base, 'host is not reachable')
          raise ArgumentError, 'host is not reachable'
        rescue ArgumentError => e
          errors.add(:base, e.message)
          raise ArgumentError, e.message
        end
      else
        raise ArgumentError, 'invalid ScanTask'
      end
    end

    private

    def wrap(list)
      songs = []
      list.each do |hash|
        songs << Article.new(hash)
      end
      return songs
    end
  end
end