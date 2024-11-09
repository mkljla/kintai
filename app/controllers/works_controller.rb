class WorksController < ApplicationController
  before_action :set_latest_records, only: [:start_work, :end_work]

  # 出勤処理
  def start_work

    return redirect_with_alert("すでに出勤済みです。") if @latest_work.working?

    # 出勤記録の新規作成
    work_record = Work.new(user_id: current_user.id, start_datetime: Time.current.change(sec: 0))

    # 出勤記録の保存
    if work_record.save
      flash[:notice] = "出勤時間を登録しました。"
    else
      flash[:alert] = "出勤時間の登録に失敗しました。"
    end

    # ホーム画面にリダイレクト
    redirect_to user_home_path
  end


  # 退勤処理
  def end_work
    # 出勤していない場合の処理を早期リターンで処理
    return redirect_with_alert("出勤していません。") unless @latest_work.working?

    # 休憩中の場合の処理を早期リターンで処理
    return redirect_with_alert("休憩中です。") if @latest_break.taking_a_break?

    begin
      ActiveRecord::Base.transaction do
        # 退勤記録の作成
        @latest_work.end_datetime = Time.current.change(sec: 0)

        # 勤務時間(休憩含む)を計算
        working_seconds = @latest_work.calculate_total_work_time
        @latest_work.total_work_time_in_minutes = (working_seconds / 60).to_i

        # 実労働時間を計算して登録
        @latest_work.actual_work_time_in_minutes = @latest_work.calculate_actual_work_time

        # 保存
        raise ActiveRecord::Rollback unless @latest_work.save

        flash[:notice] = "退勤時間を登録しました。"
        redirect_to user_home_path
      end

    rescue StandardError => e
      # 例外処理
      flash[:alert] = "休憩の終了に失敗しました: #{e.message}"
      redirect_to user_home_path
    end
  end


  private

end
