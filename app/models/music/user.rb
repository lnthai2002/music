module Music
  class User < ActiveRecord::Base
    self.table_name = 'users'

    has_one :drb_server, :dependent => :destroy
  end
end
