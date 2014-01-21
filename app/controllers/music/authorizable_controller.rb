require_dependency "music/application_controller"

module Music
  class AuthorizableController < ApplicationController
    authorize_resource

    def current_ability
      @user = User.where(:email=>session[:cas_user]).first
      Music::Ability.new(@user)
    end
  end
end
