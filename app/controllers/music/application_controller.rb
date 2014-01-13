module Music
  class ApplicationController < ActionController::Base
    before_filter CASClient::Frameworks::Rails::Filter
    layout 'music/layouts/application'
  end
end
