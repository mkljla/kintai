class UsersController < ApplicationController
  def home
    @user = current_user
    # 社員用ホーム画面の表示ロジック
    @attendances = current_user.attendances
  end

  def show
    #ユーザー詳細画面
    @user = current_user
  end
end
