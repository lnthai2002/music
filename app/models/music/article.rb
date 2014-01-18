#require 'activerecord-tableless'
module Music
  class Article < ActiveRecord::Base
    has_no_table
    column 'file', :string
    column 'timestamp', :string
    column 'title', :string
    column 'artist', :string
    column 'album', :string
    column 'year', :string
    column 'track', :string
    column 'genre', :string
    column 'comment', :string
    column 'length', :string
    column 'apic', :string

    belongs_to :write_task
    validates 'file', 'timestamp', :presence=>true
  end
end