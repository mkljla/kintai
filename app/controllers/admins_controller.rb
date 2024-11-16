class AdminsController < ApplicationController

  def home
    @sort_column = params[:sort_column] || 'employee_number' # デフォルトは社員番号
    @sort_direction = params[:sort_direction] || 'asc'      # デフォルトは昇順
    @filter = params[:filter] || 'all'                      # デフォルトは「全社員」

    @users = fetch_users.non_admin # アドミンユーザーを除外
    @users = filter_users(@users)  # フィルターを適用
    # 並べ替え
    @users = @users.order("#{sort_column} #{sort_direction}, id ASC") # 同じ値の場合idカラムの昇順に

  end

  def show_user
    @user = User.find(params[:id])
    @works = @user.works.order(created_at: :desc)
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

  def sort_column
    # 許可されていないカラムの場合employee_numberを返す
    %w[employee_number full_name_kana working_status date_of_hire date_of_termination].include?(params[:sort_column]) ? params[:sort_column] : 'employee_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

end
