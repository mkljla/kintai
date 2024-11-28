crumb :users_home do
  link "Home", home_users_path
end

crumb :users_index do
  link "社員一覧", users_path
end

crumb :users_show do
  link "社員詳細", user_path(current_user.id)
  parent :users_home
end

crumb :works_index  do |user|
  link "勤務履歴",  user_works_path(current_user)
  parent :users_home
end

crumb :works_show do |user, work|
  link "勤務詳細", work_path(user, work)
  parent :works_index
end

crumb :users_show do |user|
  link "社員詳細", user_path(user)
  parent :users_index
end

crumb :users_new do
  link "社員登録", new_user_path
  parent :users_index
end

crumb :users_edit do |user|
  link "社員編集", edit_user_path(user)
  parent :users_index
end
