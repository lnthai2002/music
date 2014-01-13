require_dependency "music/application_controller"

module Music
  class SessionsController < ApplicationController
    def logout
      reset_session
      CASClient::Frameworks::Rails::Filter.logout(self)
    end
  end
end
