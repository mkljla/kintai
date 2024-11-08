class WorksController < ApplicationController
  before_action :set_latest_records, only: [:start_work, :end_work]

  # 出勤処理
  def start_work

    return redirect_with_alert("すでに出勤済みです。") if @latest_work.working?

    # 出勤処理を実行しリダイレクト
    flash[:notice] = Work.create_work_record(current_user) ? "出勤時間を登録しました。" : "出勤時間の登録に失敗しました。"

    redirect_to user_home_path
  end


  # 退勤処理
  def end_work
    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.working?

    # 休憩中の場合の処理を早期リターンで処理
    return redirect_with_alert("休憩中です。") if @latest_break.taking_a_break?

    # 退勤処理を実行しリダイレクト
    flash[:notice] = @latest_work.register_work_end_time ?  "退勤時間を登録しました。" :  "退勤時間の登録に失敗しました。"

    # 勤務時間(休憩含む)を計算
    total_working_time = @latest_work.calculate_total_working_time_in_minutes(@latest_work)
    # 勤務時間を登録
    @latest_work.register_total_working_time(total_working_time)
    redirect_to user_home_path
  end


  private

end
