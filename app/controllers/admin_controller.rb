class AdminController < ApplicationController
  before_action :require_admin

  def toggle_admin_mode

    session[:admin_mode] = !session[:admin_mode]
    @admin_mode = session[:admin_mode]

    if @admin_mode
      redirect_to admin_users_path
    else
      redirect_to  home_users_path
    end
  end

  def require_admin_mode
    unless @admin_mode
        flash[:alert] = "管理者モードが無効です"
        redirect_to  home_users_path unless admin_mode_active?
    end
  end

  private

  def require_admin
    unless current_user.is_admin
        Rails.logger.warn "Unauthorized access attempt by user_id=#{current_user&.id}"
        flash[:alert] = "権限がありません"
        redirect_to login_path
    end
  end

end