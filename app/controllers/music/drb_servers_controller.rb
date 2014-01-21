require_dependency "music/application_controller"

module Music
  class DrbServersController < ApplicationController
    def edit
      user = User.where(email: session[:cas_user]).first
      if user.blank?
        redirect_to 'logout'
      else
        @drb_server = user.drb_server
        @drb_server ||= DrbServer.new #create new if not exist
      end
    end

    def update
      @drb_server = DrbServer.accessible_by(current_ability).first
      if @drb_server.update_attributes(drb_server_params)
        redirect_to 'songs/scan', notice: 'DRB server recorded'
      else
        render 'edit'
      end
    end

    def new
      DrbServer.new
    end

    def create
      user = User.where(:email=>session[:cas_user]).first
      server = DrbServer.new(drb_server_params)
      server.user = user
      if server.save
        redirect_to 'songs/scan', notice: 'DRB server recorded'
      else
        render 'new'
      end
    end

    private

    def drb_server_params
      params.require(:drb_server).permit(:host, :security_key)
    end
  end
end
