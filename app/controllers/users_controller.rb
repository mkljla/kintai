class UsersController < ApplicationController
  before_action :set_user
  before_action :set_latest_records

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


  # ログイン中のユーザーを設定
  def set_user
    @user = current_user
  end
end
