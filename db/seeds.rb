# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ATTENDANCE_COUNT = 100; # 作成する出勤記録の数
RETIREMENT_RATE = 1; # 退職率(0.n%)

# 部門データの作成
def create_departments
  departments = ['人事部', '経理部', '総務部', 'システム部', '営業部']
  departments.each_with_index do |department_name, index|
    Department.create!(name: department_name, sort_no: index + 1)
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
    user.family_name = "管理者"
    user.first_name = "太郎"
    user.full_name = "管理者 太郎"
    user.family_name_kana = "かんりしゃ"
    user.first_name_kana = "たろう"
    user.full_name_kana = "かんりしゃ たろう"
    user.birthday = Date.new(1950, 1, 1)
    user.date_of_hire = Date.new(1950, 1, 1)
    user.password = "admin"
    user.is_admin = true
    user.department_id = nil
  end
end

# ユーザーデータの作成
def create_users_with_works

  user = create_user

end

# ユーザーを作成
def create_user


  names = [
  { family_name: "管理者", first_name: "太郎", family_name_kana: "かんりしゃ", first_name_kana: "たろう"},
  { family_name: "鈴木", first_name: "次郎", family_name_kana: "すずき", first_name_kana: "じろう"},
  { family_name: "佐藤", first_name: "三郎", family_name_kana: "さとう", first_name_kana: "さぶろう"},
  { family_name: "高橋", first_name: "四郎", family_name_kana: "たかはし", first_name_kana: "しろう"},
  { family_name: "山田", first_name: "五郎", family_name_kana: "やまだ", first_name_kana: "ごろう"},
  { family_name: "松本", first_name: "一郎", family_name_kana: "まつもと", first_name_kana: "いちろう" },
  { family_name: "中村", first_name: "六郎", family_name_kana: "なかむら", first_name_kana: "ろくろう" },
  { family_name: "林", first_name: "七郎", family_name_kana: "はやし", first_name_kana: "しちろう" },
  { family_name: "小林", first_name: "八郎", family_name_kana: "こばやし", first_name_kana: "はちろう" },
  { family_name: "加藤", first_name: "九郎", family_name_kana: "かとう", first_name_kana: "くろう" },
  { family_name: "岡田", first_name: "十郎", family_name_kana: "おかだ", first_name_kana: "じゅうろう" },
  { family_name: "柴田", first_name: "健一", family_name_kana: "しばた", first_name_kana: "けんいち" },
  { family_name: "工藤", first_name: "健二", family_name_kana: "くどう", first_name_kana: "けんじ" },
  { family_name: "上田", first_name: "健三", family_name_kana: "うえだ", first_name_kana: "けんぞう" },
  { family_name: "森田", first_name: "健四", family_name_kana: "もりた", first_name_kana: "けんし" },
  { family_name: "藤田", first_name: "健五", family_name_kana: "ふじた", first_name_kana: "けんご" },
  { family_name: "島田", first_name: "隆一", family_name_kana: "しまだ", first_name_kana: "たかいち" },
  { family_name: "長谷川", first_name: "隆二", family_name_kana: "はせがわ", first_name_kana: "たかじ" },
  { family_name: "大野", first_name: "隆三", family_name_kana: "おおの", first_name_kana: "たかぞう" },
  { family_name: "横山", first_name: "隆四", family_name_kana: "よこやま", first_name_kana: "たかし" },
  { family_name: "竹田", first_name: "隆五", family_name_kana: "たけだ", first_name_kana: "たかご" },
  { family_name: "石田", first_name: "隆六", family_name_kana: "いしだ", first_name_kana: "たかろく" },
  { family_name: "山口", first_name: "直樹", family_name_kana: "やまぐち", first_name_kana: "なおき" },
  { family_name: "石井", first_name: "直也", family_name_kana: "いしい", first_name_kana: "なおや" },
  { family_name: "平田", first_name: "直人", family_name_kana: "ひらた", first_name_kana: "なおと" },
  { family_name: "菊池", first_name: "正樹", family_name_kana: "きくち", first_name_kana: "まさき" },
  { family_name: "松井", first_name: "正明", family_name_kana: "まつい", first_name_kana: "まさあき" },
  { family_name: "金子", first_name: "正人", family_name_kana: "かねこ", first_name_kana: "まさと" },
  { family_name: "西村", first_name: "一也", family_name_kana: "にしむら", first_name_kana: "かずや" },
  { family_name: "北村", first_name: "哲也", family_name_kana: "きたむら", first_name_kana: "てつや" },
  { family_name: "内田", first_name: "裕樹", family_name_kana: "うちだ", first_name_kana: "ひろき" },
  { family_name: "橋本", first_name: "裕太", family_name_kana: "はしもと", first_name_kana: "ゆうた" },
  { family_name: "安田", first_name: "雅也", family_name_kana: "やすだ", first_name_kana: "まさや" },
  { family_name: "三浦", first_name: "雅人", family_name_kana: "みうら", first_name_kana: "まさと" },
  { family_name: "福田", first_name: "信一", family_name_kana: "ふくだ", first_name_kana: "しんいち" },
  ]
  names.each_with_index do |name, index|

    # 生年月日を作成
    birthday =  generate_birthday_date
    # 入社日を作成
    date_of_hire = generate_hire_date(birthday)
    # 管理者ユーザーの作成
    is_admin = (index == 0)
    # 退職日を管理者以外にのみ設定
    date_of_termination = is_admin ? nil : generate_termination_date(date_of_hire)
    # 部門IDの一覧を取得
    department_ids = Department.pluck(:id)
    # 部門IDをランダムで選択
    department_id = department_ids.sample

    user=User.create!(
      employee_number: index + 1,
      family_name: name[:family_name],
      first_name: name[:first_name],
      full_name: "#{name[:family_name]} #{name[:first_name]}",
      family_name_kana: name[:family_name_kana],
      first_name_kana: name[:first_name_kana],
      full_name_kana: "#{name[:family_name_kana]} #{name[:first_name_kana]}",
      birthday: birthday,
      date_of_hire: date_of_hire,
      date_of_termination: date_of_termination,
      password: "password",
      department_id: department_id,
      is_admin: is_admin,
    )
    # 業務作成
    create_works_for_user(user.id)

    # 勤務状態の決定
    working_status = determine_working_status(user)

    # ユーザーの勤務状態を更新
    user.update(working_status: working_status)

  end
end


# 入社日を作成 (18歳以上の年齢に基づく)
def generate_hire_date(birthday)
  min_hire_year = birthday.year + 18
  max_hire_year = [Date.today.year, min_hire_year + 47].min # 退職年齢が65歳未満の場合を考慮
  year = rand(min_hire_year..max_hire_year)
  month = rand(1..12)
  day = rand(1..[Date.new(year, month, -1).day, Date.today.day].min)
  Date.new(year, month, day)
end

# 勤務状態を決定するメソッド
def determine_working_status(user)
  return "retired" if user.retired?

  # 最新の出勤履歴を取得
  latest_work = user.works.order(created_at: :desc).first

  # 最新の勤務記録があり、退勤記録がない場合は勤務中
  if latest_work&.start_datetime.present? && latest_work.end_datetime.nil?
    "working"
  else
    "not_working"
  end
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




# 退職日を作成 (入社日以降であること、存在確率10分の1)
def generate_termination_date(date_of_hire)
  return nil unless rand(1..10) == RETIREMENT_RATE # 10分の1の確率で退職日を設定

  min_termination_year = date_of_hire.year
  max_termination_year = [Date.today.year, min_termination_year + 47].min # 65歳未満で退職を考慮
  year = rand(min_termination_year..max_termination_year)
  month = rand(1..12)
  day = rand(1..[Date.new(year, month, -1).day, Date.today.day].min)
  termination_date = Date.new(year, month, day)

  # 退職日は入社日以降であることを保証
  termination_date >= date_of_hire ? termination_date : date_of_hire + rand(1..365)
end

# 退職日していればtrueを返すメソッド
def retired?(user)
  user.date_of_termination.present? && user.date_of_termination < Date.today
end

# 生年月日を作成 (現在から18年以上前であること)
def generate_birthday_date
  today = Date.today
  max_birth_year = today.year - 18
  min_birth_year = max_birth_year - 47 # 仮に65歳未満までとする
  year = rand(min_birth_year..max_birth_year)
  month = rand(1..12)
  day = rand(1..[Date.new(year, month, -1).day, today.day].min) # 過去日を保証
  Date.new(year, month, day)
end

# 入社日を作成 (18歳以上の年齢に基づく)
def generate_hire_date(birthday)
  min_hire_year = birthday.year + 18
  max_hire_year = [Date.today.year, min_hire_year + 47].min # 退職年齢が65歳未満の場合を考慮
  year = rand(min_hire_year..max_hire_year)
  month = rand(1..12)
  day = rand(1..[Date.new(year, month, -1).day, Date.today.day].min)
  Date.new(year, month, day)
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
create_users_with_works
