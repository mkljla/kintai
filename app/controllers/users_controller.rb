class UsersController < ApplicationController
  before_action :set_current_user, only:[:home] # ログイン中のユーザーを@userにセット
  before_action :set_user_by_id, only:[:show, :edit, :update] # params[:id]を@userにセット
  before_action :verify_user_by_id, only:[:show] , unless: -> { current_user.is_admin } # params[:id]とログイン中のユーザが一致するかチェック

  before_action :require_admin, only:[:index, :new, :create, :destroy, :edit, :update]

  # ホーム画面
  def home
    @works_today = @user.works.today.includes(:breaks).sorted
    @latest_work = @works_today.latest_one.first
    @breaks =  @latest_work&.breaks
  end

  # ユーザー詳細画面
  def show
  end

  # ユーザー一覧画面
  def index
    @sort_column = params[:sort_column] || 'employee_number' # デフォルトは社員番号
    @sort_direction = params[:sort_direction] || 'asc'      # デフォルトは昇順
    @filter = params[:filter] || 'active'                      # デフォルトは「在職」

    @users = User.non_admin # アドミンユーザーを除外
    @users = filter_users(@users, @filter)  # フィルターを適用

    # 部門でソートする場合の処理
    if @sort_column == 'department_sort_no'
      @users = @users.joins(:department)
                      .order("departments.sort_no #{@sort_direction}, users.id ASC")
    else
      # 並べ替え
      @users = @users.order("#{sort_column} #{sort_direction}, id ASC")
    end

  end

  # ユーザー作成画面
  def new
    @departments = Department.sorted
    @employee_number = User.next_employee_number.to_s.rjust(4, '0')
    @user = User.new
  end

  # ユーザー作成処理
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
      redirect_to users_path
    else
      Rails.logger.debug("User save failed: #{@user.errors.full_messages}")
      flash[:alert] = "ユーザー登録に失敗しました。"
      # 値を保持
      render :new
    end
  end

  # ユーザー削除
  def destroy

    user = User.find(params[:id])
    if user.destroy
      flash[:notice] = "ユーザーを削除しました。"
      redirect_to users_path
    else
      flash[:alert] = "ユーザーの削除に失敗しました。"
      redirect_to users_path
    end

  end

  # ユーザー編集
  def edit
    @departments = Department.sorted
    @employee_number = @user.employee_number.to_s.rjust(4, '0')

  end

  # ユーザー更新処理
  def update
    # 表示用
    @employee_number = User.next_employee_number
    @departments = Department.sorted

    if @user.update(user_params.merge(
      employee_number:  @user.employee_number,
      full_name: "#{user_params[:family_name]} #{user_params[:first_name]}",
      full_name_kana: "#{user_params[:family_name_kana]} #{user_params[:first_name_kana]}",
      password: Date.parse(user_params[:birthday]).strftime('%Y%m%d'),

      ))
      flash[:notice] = "ユーザー情報を更新しました。"
      redirect_to users_path
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
    %w[employee_number full_name_kana working_status date_of_hire date_of_termination department_sort_no ].include?(params[:sort_column]) ? params[:sort_column] : 'employee_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end


end
