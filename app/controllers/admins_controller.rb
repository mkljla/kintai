class AdminsController < ApplicationController

  def home
    @sort_column = params[:sort_column] || 'employee_number' # デフォルトは社員番号
    @sort_direction = params[:sort_direction] || 'asc'      # デフォルトは昇順
    @filter = params[:filter] || 'all'                      # デフォルトは「全社員」

    @users = User.non_admin # アドミンユーザーを除外
    @users = filter_users(@users, @filter)  # フィルターを適用
    # 並べ替え
    @users = @users.order("#{sort_column} #{sort_direction}, id ASC") # 同じ値の場合idカラムの昇順に

  end

  def show_user
    @user = User.find(params[:id])
    @works = @user.works.order(created_at: :desc)
  end

  private

  # フィルタリング条件に応じてユーザーを絞り込むメソッド
  def filter_users(users, filter)
    case filter
    when 'active'
      users.active # 在職ユーザーのみを取得
    when 'retired'
      users.retired # 退職済みユーザーのみを取得
    else
      users # 全ユーザーを返す
    end
  end

  def sort_column
    # 許可されていないカラムの場合employee_numberを返す
    %w[employee_number full_name_kana working_status date_of_hire date_of_termination].include?(params[:sort_column]) ? params[:sort_column] : 'employee_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

  def require_admin
    unless current_user.is_admin
      flash[:alert] = "権限がありません"
      redirect_to login_path
    end
  end
end
