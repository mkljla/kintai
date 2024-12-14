class UsersController < ApplicationController
  before_action :set_current_user, only:[:home] # ログイン中のユーザーを@userにセット
  before_action -> { set_and_verify_user(:id) }, only:[:show]

  # ホーム画面
  def home
    @works_today = @user.works.today.includes(:breaks).sorted
    @work = @works_today.latest_one.first
    @breaks =  @work&.breaks&.order(:start_datetime, :id)
  end

  # ユーザー詳細画面
  def show
  end

  private


end
