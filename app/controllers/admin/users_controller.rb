class Admin::UsersController < AdminController
  before_action :require_admin_mode
  before_action -> { set_and_verify_user(:id) }, only:[ :edit, :update]

  # ユーザー一覧画面
  def index

    @sort_column = params[:sort_column] || 'employee_number' # デフォルトは社員番号
    @sort_direction = params[:sort_direction] || 'asc'      # デフォルトは昇順
    @filter = params[:filter] || 'active'                   # デフォルトは「在職」
    @department_id = params[:department_id].presence || ''   # 部署ID（フィルター）、初期値は空

    @users = User.all
    @users = filter_users(@users, @filter) # ステータスフィルターを適用

    # 部署IDが指定されている場合の絞り込み
    if @department_id.present?
      if @department_id == 'none'
        @users = @users.where(department_id: nil) # 未選択（NULL）の場合
      else
        @users = @users.where(department_id: @department_id) # 指定された部署IDの場合
      end
    end
    @department_label = department_filter_label(@department_id)
    @employee_label = employee_filter_label(@filter)

    # 並べ替え
    @users = @users.order("#{sort_column} #{sort_direction}, id ASC")
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
      redirect_to admin_users_path
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
      flash[:notice] = "#{user.full_name}さんを削除しました。"
      redirect_to admin_users_path
    else
      flash[:alert] = "#{user.full_name}さんの削除に失敗しました。"
      redirect_to admin_users_path
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
      flash[:notice] = "#{@user.full_name}さんの情報を更新しました。"
      redirect_to admin_users_path
    else
      Rails.logger.debug("User update failed: #{@user.errors.full_messages}")
      flash[:alert] = "#{user.full_name}さんの情報の更新に失敗しました。"
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
      users.active # 在職中
    when 'retired'
      users.retired # 退職済
    else
      users # 全社員
    end
  end

  def department_filter_label(id)
    case id
    when ''
      'すべて'
    when 'none'
      '未設定'
    else
      department = Department.find_by(id: id)
      department.name
    end
  end

  def employee_filter_label(filter)
    case filter
      when 'active'
        '在職中'
      when 'retired'
        '退職済'
      else
        '全社員'
      end
  end

  def sort_column
    # 許可されていないカラムの場合employee_numberを返す
    %w[employee_number full_name_kana working_status date_of_hire date_of_termination ].include?(params[:sort_column]) ? params[:sort_column] : 'employee_number'
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
  end

end
