class WorksController < ApplicationController
  before_action -> { set_and_verify_user(:user_id) }, only:[:index, :show]
  before_action -> { set_and_verify_work(:id)}, only:[:show] # params[:id]を@workにセット
  before_action :set_latest_records, only:[:update] # 最新のworkとbreakを取得

  def index
    @works = @user.works.sorted # ユーザーの出勤簿を取得


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
    @works_by_date = @works.where(start_datetime: start_date..end_date).group_by { |work| work.start_datetime.to_date }

    # 日本の祝日リストを取得 (holiday_japan gemを使用)
    @holidays = HolidayJapan.between(start_date, end_date)

    # 表示している月の overtime 合計値を計算
    @total_monthly_overtime = @works.where(start_datetime: start_date..end_date).sum(:total_overtime_in_minutes)
  end

  def show
    @breaks = Break.where(work_id: @work.id)

  end

  # 出勤処理
  def create
    ActiveRecord::Base.transaction do
      # 出勤記録の新規作成
      work_record = Work.new(user_id: current_user.id, start_datetime: Time.current.change(sec: 0))

      # 出勤記録の保存
      work_record.save!
      # ステータスを勤務中に更新
      current_user.update!(working_status: :working)
    end

    flash[:notice] = "出勤時間を登録しました。"
    redirect_to home_users_path

  rescue StandardError => e
    flash[:alert] = "出勤時間の登録に失敗しました。"
    Rails.logger.error("Error during work creation: #{e.message}")
    redirect_to home_users_path
  end


  # 退勤処理
  def update

    ActiveRecord::Base.transaction do
      # 退勤記録の作成
      @latest_work.end_datetime = Time.current.change(sec: 0)

      # 勤務時間(休憩含む)を計算
      working_seconds = @latest_work.calculate_total_work_time
      @latest_work.total_work_time_in_minutes = (working_seconds / 60).to_i

      # 実労働時間を計算
      @latest_work.actual_work_time_in_minutes = @latest_work.calculate_actual_work_time
      # 残業時間を計算
      @latest_work.total_overtime_in_minutes = @latest_work.calculate_overtime(MWorkHourSetting.standard_work_in_minutes)

      # 保存
      @latest_work.save!
      # ステータスを勤務外に更新
      current_user.update!(working_status: :not_working)
    end

    flash[:notice] = "退勤時間を登録しました。"
    redirect_to home_users_path


  rescue StandardError => e
    # 例外処理
    flash[:alert] = "退勤時間の終了に失敗しました"
    Rails.logger.error("Error during work update: #{e.message}")
    redirect_to home_users_path
  end


  private


end
