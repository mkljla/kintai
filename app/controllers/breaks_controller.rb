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
    # 休憩終了処理を実行しリダイレクト
    flash[:notice] = @latest_break.set_end_time ? "休憩を終了しました。" : "休憩時間の登録に失敗しました。"

    redirect_to user_home_path
  end

  private

end
