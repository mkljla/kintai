class Admin::UsersController < ApplicationController

  def index
    @sort_column = params[:sort_column] || 'employee_number' # デフォルトは社員番号
    @sort_direction = params[:sort_direction] || 'asc'      # デフォルトは昇順
    @filter = params[:filter] || 'all'                      # デフォルトは「全社員」

    @users = User.non_admin # アドミンユーザーを除外
    @users = filter_users(@users, @filter)  # フィルターを適用
    # 並べ替え
    @users = @users.order("#{sort_column} #{sort_direction}, id ASC") # 同じ値の場合idカラムの昇順に

  end

  def show
    @user = User.find(params[:id])
    @works = @user.works.order(created_at: :desc)
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
      redirect_to admin_users_path
    else
      Rails.logger.debug("User save failed: #{@user.errors.full_messages}")
      flash[:alert] = "ユーザー登録に失敗しました。"
      # 値を保持
      render :new
    end
  end

  def destroy

    user = User.find(params[:id])
    if user.destroy
      flash[:notice] = "ユーザーを削除しました。"
      redirect_to admin_users_path
    else
      flash[:alert] = "ユーザーの削除に失敗しました。"
      render :home
    end

  end

  def edit
    @user = User.find(params[:id])
    @departments = Department.sorted
    @employee_number = @user.employee_number.to_s.rjust(4, '0')
  end

  def update
    binding.pry

    # 表示用
    @employee_number = User.next_employee_number
    @departments = Department.sorted
    @user = User.find(params[:id])

    if @user.update(user_params.merge(
      employee_number:  @user.employee_number,
      full_name: "#{user_params[:family_name]} #{user_params[:first_name]}",
      full_name_kana: "#{user_params[:family_name_kana]} #{user_params[:first_name_kana]}",
      password: Date.parse(user_params[:birthday]).strftime('%Y%m%d'),

      ))
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to admin_users_path
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
      :birthday, :date_of_hire, :date_of_termination
    )
  end

  # # ログイン中のユーザーを設定
  # def set_user
  #   @user = current_user
  # end

  # フィルタリング条件に応じてユーザーを絞り込むメソッド
  def filter_users(users, filter)
    case filter
    when 'active'
      users.active # 在職ユーザーのみを取得
    when 'retired'
      users.retired # 退職済みユーザーのみを取得
    else
      users # 全ユーザーを返す
    end
  end

  def sort_column
    # 許可されていないカラムの場合employee_numberを返す
    %w[employee_number full_name_kana working_status date_of_hire date_of_termination].include?(params[:sort_column]) ? params[:sort_column] : 'employee_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

end
