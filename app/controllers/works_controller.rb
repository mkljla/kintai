class WorksController < ApplicationController
  before_action :set_latest_records, only: [:check_in, :check_out]
  # 出勤処理
  def check_in

    return redirect_with_alert("すでに出勤済みです。") if @latest_work.working?

    # 出勤処理を実行しリダイレクト
    register_check_in
    redirect_to user_home_path
  end


  # 退勤処理
  def check_out
    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.working?

    # 休憩中の場合の処理を早期リターンで処理
    return redirect_with_alert("休憩中です。") if @latest_break.taking_a_break?

    # 退勤処理を実行しリダイレクト
    register_check_out
    redirect_to user_home_path
  end


  private



  # 出勤時間を登録する
  def register_check_in
    if Work.create_with_check_in(current_user)
      flash[:notice] = "出勤時間を登録しました。"
    else
      flash[:alert] = "出勤時間の登録に失敗しました。"
    end
  end

  # 退勤時間を登録する
  def register_check_out
    if @latest_work.set_check_out
      flash[:notice] = "退勤時間を登録しました。"
    else
      flash[:alert] = "退勤時間の登録に失敗しました。"
    end
  end


  # # 労働時間を計算するメソッド
  # def calculate_working_hours(work)
  #   if work.start_datetime && work.end_datetime
  #     working_seconds = work.end_datetime - work.start_datetime
  #     work.total_working_in_minutes = (working_seconds / 60).to_i
  #   end
  # end

  # # 休憩時間を計算するメソッド
  # def calculate_break_time(break_time)
  #   if break_time.start_datetime && break_time.end_datetime
  #     break_seconds = break_time.end_datetime - break_time.start_datetime
  #     break_time.total_break_time_in_minutes = (break_seconds / 60).to_i
  #   end
  # end


end
