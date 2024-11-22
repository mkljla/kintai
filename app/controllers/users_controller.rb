class UsersController < ApplicationController
  before_action :set_user
  before_action :set_latest_records

  # ホーム画面
  def home
    @works = @user.works.sorted.limit(5) # 最新の出勤記録を5件取得
    @works_today = @user.works.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).includes(:breaks).sorted

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
