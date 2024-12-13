class BreaksController < ApplicationController
  before_action :set_latest_records, only: [:create, :update]

  # 休憩開始処理
  def create

    ActiveRecord::Base.transaction do
      # 休憩記録の新規作成
      break_record = Break.new(work_id: @latest_work.id, start_datetime: Time.current.change(sec: 0))

      # 休憩記録の保存
      break_record.save!
      # ステータスを休憩中に更新
      current_user.update!(working_status: :breaking)
    end

    flash[:notice] = "休憩を開始しました。"
    redirect_to  home_users_path

  rescue StandardError => e
    Rails.logger.error("Error during break creation: #{e.message}")
    flash[:alert] = "休憩時間の登録に失敗しました。"
    redirect_to  home_users_path
  end

  def update
    ActiveRecord::Base.transaction do
      # 休憩終了時間を登録
      @latest_break.end_datetime = Time.current.change(sec: 0)

      # 休憩時間を計算
      break_seconds = @latest_break.calculate_break_time
      # 休憩時間を登録
      @latest_break.break_time_in_minutes = (break_seconds / 60).to_i

      @latest_break.save!

      # 累計休憩時間を登録
      @latest_work.total_break_time_in_minutes = @latest_work.calculate_total_break_time
      # バリデーションコンテキストを指定
      @latest_work.validation_context = :break_update

      @latest_work.save!
      # ステータスを勤務中に更新
      current_user.update!(working_status: :working)
    end

    flash[:notice] = "休憩を終了しました。"
    redirect_to  home_users_path

  rescue StandardError => e
    # 例外処理
    Rails.logger.error("Error during break update: #{e.message}")
    flash[:alert] = "休憩の終了に失敗しました"
    redirect_to  home_users_path
  end

end

