class UsersController < ApplicationController
  before_action :set_user

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

  end

  def new
    @departments = Department.sorted
    @employee_number = User.next_employee_number
    @user = User.new
  end

  def create

    User.create(user_params.merge(
      full_name: "#{user_params[:family_name]} #{user_params[:first_name]}",
      full_name_kana: "#{user_params[:family_name_kana]} #{user_params[:first_name_kana]}",
      password: Date.parse(user_params[:birthday]).strftime('%Y%m%d')
    ))

    if @user.save
      flash[:notice] = "新規ユーザーを登録しました。"
      redirect_to admin_home_path
    else
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

  private

  def user_params
    params.require(:user).permit(
      :employee_number, :family_name, :first_name, :family_name_kana, :first_name_kana,
      :birthday, :date_of_hire, :department_id
    )
  end
  # ログイン中のユーザーを設定
  def set_user
    @user = current_user
  end
end
