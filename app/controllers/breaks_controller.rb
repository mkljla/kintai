class BreaksController < ApplicationController
  before_action :set_latest_records, only: [:start_break, :end_break]

  # 休憩開始処理
  def start_break

    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless current_user.working?

    # 休憩開始している場合の処理を早期リターンで処理
    return redirect_with_alert("すでに休憩中です。") if current_user.taking_a_break?

    # 休憩記録の新規作成
    break_record = Break.new(work_id: @latest_work.id, start_datetime: Time.current.change(sec: 0))

    # 休憩記録の保存
    if break_record.save
      flash[:notice] = "休憩を開始しました。"
    else
      flash[:alert] = "休憩時間の登録に失敗しました。"
    end

    redirect_to user_home_path

  end

  def end_break
    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless current_user.working?
    # 休憩開始していない場合の処理を早期リターンで処理
    return redirect_with_alert("休憩を開始していません。") unless current_user.taking_a_break?

    begin
      ActiveRecord::Base.transaction do
        # 休憩終了時間を登録
        @latest_break.end_datetime = Time.current.change(sec: 0)

        # 休憩時間を計算
        break_seconds = @latest_break.calculate_break_time
        # 休憩時間を登録
        @latest_break.break_time_in_minutes = (break_seconds / 60).to_i

        raise ActiveRecord::Rollback unless @latest_break.save

        # 累計休憩時間を登録
        @latest_work.total_break_time_in_minutes = @latest_work.calculate_total_break_time

        raise ActiveRecord::Rollback unless @latest_work.save

        flash[:notice] = "休憩を終了しました。"
        redirect_to user_home_path
      end

    rescue StandardError => e
      # 例外処理
      flash[:alert] = "休憩の終了に失敗しました: #{e.message}"
      redirect_to user_home_path
    end
  end


end

