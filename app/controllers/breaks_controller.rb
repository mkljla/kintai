class BreaksController < ApplicationController
  before_action :set_latest_records, only: [:start_break, :end_break]

  # 休憩開始処理
  def start_break

    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.working?

    # 休憩開始している場合の処理を早期リターンで処理
    return redirect_with_alert("すでに休憩中です。") if @latest_break.taking_a_break?

    # 休憩開始処理を実行しリダイレクト
    flash[:notice] = Break.create_with_start_time(@latest_work) ? "休憩を開始しました。" : "休憩時間の登録に失敗しました。"
    redirect_to user_home_path

  end

  def end_break
    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.working?
    # 休憩開始していない場合の処理を早期リターンで処理
    return redirect_with_alert("休憩を開始していません。") unless @latest_break.taking_a_break?

    ActiveRecord::Base.transaction do
      # 休憩終了時間を登録
      raise ActiveRecord::Rollback unless @latest_break.set_end_time
      # 休憩時間を計算
      break_time = @latest_break.calculate_total_break_time_in_minutes(@latest_break)
      # 休憩時間を保存
      raise ActiveRecord::Rollback unless @latest_work.register_total_break_time_in_minutes(break_time)
    end

    flash[:notice] = "休憩を終了しました。"
    redirect_to user_home_path

    rescue StandardError => e
      # 例外処理
      flash[:alert] = "休憩の終了に失敗しました: #{e.message}"
      redirect_to user_home_path
    end
  end

