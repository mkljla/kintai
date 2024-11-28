class UsersController < ApplicationController
  before_action :set_current_user, only:[:home]
  before_action :set_user_by_id, only:[:show]
  before_action :verify_user_by_id, only:[:show]

  # ホーム画面
  def home
    @works_today = @user.works.today.includes(:breaks).sorted
    @latest_work = @works_today.latest_one.first
    @breaks =  @latest_work&.breaks
  end

  # ユーザー詳細画面
  def show

  end

  private



end
