#require 'activerecord-tableless'
module Music
  class ScanTask < ActiveRecord::Base
    has_no_table

    column 'host', :string
    column 'security_key', :string
    column 'folder', :string
    column 'recursive', :boolean

    validates 'host', 'folder', :presence=>true
    
    def execute
      if self.valid?
        tag_reader = DRbObject.new(nil, "druby://#{host}:54322") #RFM::Handler::TagReader
        crawler = DRbObject.new(nil, "druby://#{host}:54321") #RFM::Lib::DiskCrawler
        begin
          return wrap(crawler.scan_and_process_files(folder, tag_reader, recursive, security_key){|file|
            tag_reader.read_mp3(file)
          })
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

    def wrap(list)
      songs = []
      list.each do |hash|
        songs << Article.new(hash)
      end
      return songs
    end
  end
end