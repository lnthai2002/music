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
        remoteFS = DRbObject.new(nil, "druby://#{drb_server.host}:54321") #RFM::Public::FileSystem
        begin
          return wrap(remoteFS.find_mp3(folder, recursive, drb_server.security_key))
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

    def wrap(hash)
      songs = []
      hash.each do |file, tags|
        song = Article.new(tags)
        song.file = file
        songs << song
      end
      return songs
    end
  end
end