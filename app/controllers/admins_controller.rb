class AdminsController < ApplicationController
  def home
    # ユーザーを取得し、フィルタリング処理を呼び出す
    @users = fetch_users

  end

  private

  # ユーザーの取得とフィルタリングを行うメソッド
  def fetch_users
    # 管理者以外のユーザーを取得
    filtered_users = User.where(is_admin: false)

    # フィルタリングを適用
    filtered_users = filter_users(filtered_users)

    # 最終的に社員番号の小さい順に並び替え
    filtered_users.ordered_by_employee_number
  end

  # フィルタリング条件に応じてユーザーを絞り込むメソッド
  def filter_users(users)
    case params[:filter]
    when 'active'
      # 在職ユーザーのみを取得
      users.active
    when 'retired'
      # 退職済みユーザーのみを取得
      users.retired
    when 'all'
      # 全ユーザーを返す
      users
    else
      # フィルターが指定されていない場合、全ユーザーを返す
      users
    end
  end
end
