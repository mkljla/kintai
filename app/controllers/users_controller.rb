class UsersController < ApplicationController
  before_action :set_user
  before_action :set_latest_records, only: [:home]

  # ホーム画面
  def home
    @works = @user.works.sorted.limit(5) # 最新の出勤記録を5件取得
    @works_today = @user.works.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).includes(:breaks).sorted

  end

  # ユーザー詳細画面
  def show

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

  end

  def new
    @departments = Department.sorted
    @employee_number = User.next_employee_number.to_s.rjust(4, '0')
    @user = User.new
  end

  def create
    @employee_number = User.next_employee_number.to_s.rjust(4, '0')
    @departments = Department.sorted

    @user = User.new(user_params.merge(
      employee_number:  User.next_employee_number,
      full_name: "#{user_params[:family_name]} #{user_params[:first_name]}",
      full_name_kana: "#{user_params[:family_name_kana]} #{user_params[:first_name_kana]}",
      password: Date.parse(user_params[:birthday]).strftime('%Y%m%d'),
      working_status: "not_working"
    ))

    if @user.save
      flash[:notice] = "新規ユーザーを登録しました。"
      redirect_to admin_home_path
    else
      Rails.logger.debug("User save failed: #{@user.errors.full_messages}")
      flash[:alert] = "ユーザー登録に失敗しました。"
      # 値を保持
      render :new
    end
  end

  def destroy
    if current_user.is_admin?
      user = User.find(params[:id])
      if user.destroy
        flash[:notice] = "ユーザーを削除しました。"
        redirect_to admin_home_path
      else
        flash[:alert] = "ユーザーの削除に失敗しました。"
        render :home
      end
    else
      flash[:alert] = "権限がありません。"
    end
  end

  def edit
    @user = User.find(params[:id])
    @departments = Department.sorted
    @employee_number = @user.employee_number.to_s.rjust(4, '0')
  end

  def update
    # 表示用
    @employee_number = User.next_employee_number
    @departments = Department.sorted
    @user = User.find(params[:id])

    if @user.update(user_params.merge(
      employee_number:  @user.employee_number,
      full_name: "#{user_params[:family_name]} #{user_params[:first_name]}",
      full_name_kana: "#{user_params[:family_name_kana]} #{user_params[:first_name_kana]}",
      password: Date.parse(user_params[:birthday]).strftime('%Y%m%d')
    ))
    flash[:notice] = "ユーザー情報を更新しました。"
    redirect_to admin_home_path
    else
      Rails.logger.debug("User update failed: #{@user.errors.full_messages}")
      flash[:alert] = "ユーザー情報の更新に失敗しました。"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :department_id, :family_name, :first_name, :family_name_kana, :first_name_kana,
      :birthday, :date_of_hire
    )

  end
  # ログイン中のユーザーを設定
  def set_user
    @user = current_user
  end
end
