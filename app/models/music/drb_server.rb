module Music
  class DrbServer < ActiveRecord::Base
    belongs_to :user
  end
end
