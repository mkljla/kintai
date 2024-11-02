class UsersController < ApplicationController
  before_action :set_user

  # ホーム画面
  def home
    @attendances = @user.attendances.sorted.limit(5) # 最新の出勤記録を5件取得
    @attendances_today = @user.attendances.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).includes(:breaks).sorted

  end

  # ユーザー詳細画面
  def show

    @attendances = @user.attendances.sorted # ユーザーの出勤簿を取得


    # 年月パラメータを受け取り、デフォルトは現在の年と月
    @year = params[:year]&.to_i || Time.current.year
    @month = params[:month]&.to_i || Time.current.month
    @current_year = Time.current.year
    @current_month = Time.current.month

    # 選択した年月の1日と末日を取得
    start_date = Date.new(@year, @month, 1)
    end_date = start_date.end_of_month

    # 表示する全ての日付リストを配列として作成
    @dates = (start_date..end_date).to_a

    # 選択した期間内の出勤データを取得し、日付でグループ化
    @attendances_by_date = @attendances.where(check_in_datetime: start_date..end_date).group_by { |attendance| attendance.check_in_datetime.to_date }

  end

  private

  # ログイン中のユーザーを設定
  def set_user
    @user = current_user
  end
end
