class AdminController < ApplicationController
  before_action :set_admin_mode

  def toggle_admin_mode
    session[:admin_mode] = !session[:admin_mode]
    @admin_mode = session[:admin_mode]

    if @admin_mode
      redirect_to users_path
    else
      redirect_to home_users_path
    end
  end

  private


end