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
def create_users_with_works
  USER_COUNT.times do |n|
    user = create_user(n)
    create_works_for_user(user.id)
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
def create_works_for_user(user_id)

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

    # work_dateに基づいてランダムな出勤時間を生成
    start_datetime = generate_start_datetime(reference_date)
    # 出勤時間に基づいてランダムな退勤時間を生成
    end_datetime = generate_end_datetime(start_datetime)
    # 勤務時間を計算
    total_working_time = calculate_total_work_time(start_datetime, end_datetime)
    work = Work.create!(
      user_id: user_id,
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      total_work_time_in_minutes: total_working_time,
      created_at: start_datetime
    )
    # 休憩開始・終了時間を生成し、対応するBreakレコードを作成
    start_datetime = generate_break_start_datetime(start_datetime, end_datetime).change(sec: 0)
    end_datetime = generate_break_end_datetime(start_datetime).change(sec: 0)
    # 休憩時間を計算する
    break_time = calculate_total_break_time_in_minutes(start_datetime, end_datetime)

    Break.create!(
      work_id: work.id,
      start_datetime: start_datetime,
      end_datetime: end_datetime,
      created_at: start_datetime,
      break_time_in_minutes: break_time
    )
    # 休憩時間合計
    work.total_break_time_in_minutes += break_time
    # 実労働時間
    work.actual_work_time_in_minutes = total_working_time -  work.total_break_time_in_minutes
    # 残業時間
    overtime = work.actual_work_time_in_minutes - MWorkHourSetting.first&.standard_working_time_minutes*60
    if overtime < 0
      overtime = 0
    end
    work.total_overtime_in_minutes = overtime
    # 更新を保存
    work.save!

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
def generate_start_datetime(work_date)
  hour = rand(7..9)  # 出勤時間の時間
  minute = rand(0..59)  # 出勤時間の分
  Time.zone.local(work_date.year, work_date.month, work_date.day, hour, minute)
end

# ランダムな退勤時間を生成
def generate_end_datetime(start_datetime)
  # 出勤時間から9〜11時間後の退勤時間を生成
  hour = start_datetime.hour + rand(9..11)
  minute = rand(0..59)  # 退勤時間の分
  Time.zone.local(start_datetime.year, start_datetime.month, start_datetime.day, hour, minute)
end

# 休憩開始時間を生成
def generate_break_start_datetime(start_datetime, end_datetime)
  rand(start_datetime + 2.hours..end_datetime - 2.hours)
end

# 休憩終了時間を生成
def generate_break_end_datetime(start_datetime)
  start_datetime + rand(60..90).minutes
end

# 労働時間を計算する
def calculate_total_work_time(start_datetime, end_datetime)
  working_seconds = end_datetime - start_datetime
  (working_seconds / 60).to_i
end

# 休憩時間を計算する
def calculate_total_break_time_in_minutes(start_datetime, end_datetime)
  break_seconds = end_datetime - start_datetime
  (break_seconds / 60).to_i
end



# Seed実行
create_departments
create_m_work_hour_settings
create_admin_user
create_users_with_works
