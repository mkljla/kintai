# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ATTENDANCE_COUNT = 5; # 作成する出勤記録の数
USER_COUNT = 5; # 作成するユーザーの数
RETIREMENT_RATE = 30; # 退職率(%)

# 部門データの作成
def create_departments
  departments = ['総務', '経理']
  departments.each do |department_name|
    Department.find_or_create_by!(name: department_name)
  end
end

def create_m_work_hour_settings
  MWorkHourSetting.create!(
  standard_working_time_minutes: 8,
  applicable_start_date: Date.new(1950, 1, 1),
  applicable_end_date: nil
  )
end

# 管理者ユーザーの作成
def create_admin_user
  User.find_or_create_by!(employee_number: 0) do |user|
    user.full_name = "管理者"
    user.date_of_hire = Date.new(2000, 1, 1)
    user.password = "admin"
    user.is_admin = true
    user.department_id = nil
  end
end

# ユーザーデータの作成
def create_users_with_attendances
  USER_COUNT.times do |n|
    user = create_user(n)
    create_attendances_for_user(user.id)
  end
end

# ユーザーを作成
def create_user(index)
  # 入社日を作成
  date_of_hire = generate_hire_date()
  # 退職日を作成
  date_of_termination = randomly_retired? ? generate_termination_date(date_of_hire) : nil

  User.create!(
    employee_number: index + 1,
    full_name: "テスト太郎#{index + 1}",
    date_of_hire: date_of_hire,
    date_of_termination: date_of_termination,
    password: "password#{index + 1}",
    department_id: nil,
  )
end

# ユーザーの出勤記録を作成
def create_attendances_for_user(user_id)

  # ユーザーを取得
  user = User.find(user_id)
  # 在職なら昨日、退職していれば退職日を最新の出勤日に設定する
  reference_date = retired?(user) ? user.date_of_termination : Date.yesterday

  count = 0
  while count < ATTENDANCE_COUNT
    # 土日をスキップ
    if reference_date.saturday? || reference_date.sunday?
      reference_date -= 1
      next
    end

    # attendance_dateに基づいてランダムな出勤時間を生成
    check_in_datetime = generate_check_in_datetime(reference_date)
    # 出勤時間に基づいてランダムな退勤時間を生成
    check_out_datetime = generate_check_out_datetime(check_in_datetime)
    attendance = Attendance.create!(
      user_id: user_id,
      check_in_datetime: check_in_datetime,
      check_out_datetime: check_out_datetime,
      total_working_time_in_minutes: 60,
      created_at: check_in_datetime
    )
    # 休憩開始・終了時間を生成し、対応するBreakレコードを作成
    break_start_datetime = generate_break_start_datetime(check_in_datetime, check_out_datetime)
    break_end_datetime = generate_break_end_datetime(break_start_datetime)

    Break.create!(
      attendance_id: attendance.id,
      break_start_datetime: break_start_datetime,
      break_end_datetime: break_end_datetime,
      total_break_time_in_minutes: ((break_end_datetime - break_start_datetime) / 60).to_i,
      created_at: break_start_datetime
    )
    count += 1
    # 一日さかのぼる
    reference_date -= 1
  end
end

# 退職しているかを判定
def randomly_retired?
  rand(100) < RETIREMENT_RATE
end


# 退職日を生成
def generate_termination_date(date_of_hire)
  Random.rand(date_of_hire..Date.today)
end

# 退職日が設定されていればtrueを返すメソッド
def retired?(user)
  !user.date_of_termination.nil?
end

# ランダムな入社日を生成
def generate_hire_date
  end_date = Date.today
  start_year = 30
  start_date = end_date - start_year * 365
  Random.rand(start_date..end_date)
end

# ランダムな出勤時間を生成
def generate_check_in_datetime(attendance_date)
  hour = rand(7..9)  # 出勤時間の時間
  minute = rand(0..59)  # 出勤時間の分
  Time.zone.local(attendance_date.year, attendance_date.month, attendance_date.day, hour, minute)
end

# ランダムな退勤時間を生成
def generate_check_out_datetime(check_in_datetime)
  # 出勤時間から9〜11時間後の退勤時間を生成
  hour = check_in_datetime.hour + rand(9..11)
  minute = rand(0..59)  # 退勤時間の分
  Time.zone.local(check_in_datetime.year, check_in_datetime.month, check_in_datetime.day, hour, minute)
end

# 休憩開始時間を生成
def generate_break_start_datetime(check_in_datetime, check_out_datetime)
  rand(check_in_datetime + 2.hours..check_out_datetime - 2.hours)
end

# 休憩終了時間を生成
def generate_break_end_datetime(break_start_datetime)
  break_start_datetime + rand(30..60).minutes
end

# Seed実行
create_departments
create_m_work_hour_settings
create_admin_user
create_users_with_attendances
