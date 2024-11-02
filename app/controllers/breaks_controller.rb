class BreaksController < ApplicationController
  before_action :set_latest_records, only: [:start_break, :end_break]

  # 休憩開始処理
  def start_break

    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.checked_in?

    # 休憩開始している場合の処理を早期リターンで処理
    return redirect_with_alert("すでに休憩中です。") if @latest_break.on_break?

    # 休憩開始処理を実行しリダイレクト
    register_break_start
    redirect_to user_home_path

  end

  def end_break
    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.checked_in?
    # 休憩開始していない場合の処理を早期リターンで処理
    return redirect_with_alert("休憩を開始していません。") unless @latest_break.on_break?
    # 休憩終了処理を実行しリダイレクト
    register_break_end
    redirect_to user_home_path
  end

  private

  # 休憩開始の登録
  def register_break_start
    if Break.create_with_start_time(@latest_work)
      flash[:notice] = "休憩を開始しました。"
    else
      flash[:alert] = "休憩時間の登録に失敗しました。"
    end
  end

  # 休憩終了の登録処理
  def register_break_end
    if @latest_break.set_end_time
      flash[:notice] = "休憩を終了しました。"
    else
      flash[:alert] = "休憩時間の登録に失敗しました。"
    end
  end
end
