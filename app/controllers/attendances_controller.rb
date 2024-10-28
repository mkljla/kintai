class AttendancesController < ApplicationController
  # 出勤処理
  def check_in
    time = Time.current # 現在の時刻を取得

    # 最新のレコードを取得 (最初の1件を取得)
    @attendance = current_user.attendances.order(updated_at: :desc).first

    # 最新のレコードが存在しない、もしくは出勤・退勤が両方記録されている場合は新しいレコードを作成
    if @attendance.nil? || (@attendance.check_in_time.present? && @attendance.check_out_time.present?)
      # 新たなレコードを作成し出勤時間を設定
      @attendance = Attendance.new(user_id: current_user.id, check_in_time: time)

      if @attendance.save
        flash[:notice] = "出勤時間を登録しました。"
      else
        flash[:alert] = "出勤時間の登録に失敗しました。"
      end
    else
      flash[:alert] = "すでに出勤済みです。"
    end

    # ホーム画面にリダイレクト
    redirect_to user_home_path
  end


  # 退勤処理
  def check_out
    time = Time.current # 現在の時刻を取得

    # 最新のレコードを取得 (最初の1件を取得)
    @attendance = current_user.attendances.order(updated_at: :desc).first

    # 出勤時間があり、退勤時間がまだ設定されていない場合のみ、退勤時間を現在時刻で登録
    if @attendance&.check_in_time.present? && @attendance.check_out_time.nil?
      @attendance.check_out_time = time
      if @attendance.save
        flash[:notice] = "退勤時間を登録しました。"  # 成功メッセージ
      else
        flash[:alert] = "退勤時間の登録に失敗しました。"  # 失敗メッセージ
      end
    else
      flash[:alert] = "出勤していないか、すでに退勤済みです。"  # 出勤していないか、すでに退勤済みの場合のメッセージ
    end

    # ホーム画面にリダイレクト
    redirect_to user_home_path
  end
end
