class WorksController < ApplicationController
  before_action -> { set_and_verify_user(:user_id) }, only:[:index, :show, :get_timeline_data]
  before_action -> { set_and_verify_work(:id)}, only:[:show, :get_timeline_data] # params[:id]を@workにセット
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
    @breaks = Break.where(work_id: @work.id).order(:start_datetime, :id)

    # ユーザーが所持している勤務データを日付順（または適切な順序）で取得
    user_works = @user.works.order(:start_datetime)

    # 現在の @work の位置を見つける
    work_index = user_works.index(@work)

    # 前の勤務を取得
    @prev_work = work_index > 0 ? user_works[work_index - 1] : nil
    # 次の勤務を取得
    @next_work = work_index < user_works.length - 1 ? user_works[work_index + 1] : nil

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
    redirect_to  home_users_path

  rescue StandardError => e
    flash[:alert] = "出勤時間の登録に失敗しました。"
    Rails.logger.error("Error during work creation: #{e.message}")
    redirect_to  home_users_path
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
      @latest_work.total_overtime_in_minutes = @latest_work.calculate_overtime(Company.find_by(id: 1)&.default_work_hours)
      # バリデーションコンテキストを指定
      @latest_work.validation_context = :work_update

      # 保存
      @latest_work.save!
      # ステータスを勤務外に更新
      current_user.update!(working_status: :not_working)
    end

    flash[:notice] = "退勤時間を登録しました。"
    redirect_to  home_users_path


  rescue StandardError => e
    # 例外処理
    flash[:alert] = "退勤時間の終了に失敗しました"
    Rails.logger.error("Error during work update: #{e.message}")
    redirect_to  home_users_path
  end

  def get_timeline_data

    # @workがnilの場合、タイムラインデータを返さず、何も表示しない
    if @work.nil?
      render json: { message: '最新の勤務データはありません' }, status: :no_content
      return
    end
    @breaks =  @work&.breaks&.order(:start_datetime, :id)

    # 最新の勤務の開始・終了時間
    start_time = @work.start_datetime
    end_time = @work.end_datetime

    # 休憩データを整形
    breaks_data = @breaks.map do |b|
      {
        break_id: b.id,
        start_time: b.start_datetime,
        end_time: b.end_datetime
      }
    end

    # タイムラインに必要なデータを整形
    @timeline_data = {
      start_time: start_time,
      end_time: end_time,
      breaks: breaks_data
    }

    # JSON形式でデータを返す
    render json: @timeline_data
  end
  private


end
