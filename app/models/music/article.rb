#require 'activerecord-tableless'
module Music
  class Article < ActiveRecord::Base
    has_no_table
    column 'to_save', :boolean
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
    column 'write_task_id', :integer

    belongs_to :write_task
    validates 'file', 'timestamp', :presence=>true
  end
end