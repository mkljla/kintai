crumb :users_home do
  link "Home",  home_users_path
end

crumb :users_index do
  link "社員一覧", admin_users_path
end

crumb :users_show do |user, admin_mode|

  link "社員詳細(#{truncate(user.full_name, length: 15)})", user_path(user)
  if admin_mode
    parent :users_index
  else
    parent :users_home
  end
end


crumb :works_index  do |user, admin_mode|
  link "勤務履歴(#{truncate(user.full_name, length: 15)})",  user_works_path(user)
  if admin_mode
    parent :users_index
  else
    parent :users_home
  end
end

crumb :works_show do |user, work, admin_mode|
  link "勤務詳細", user_work_path(user, work)
  parent :works_index, user, admin_mode # 引数を渡す
end


crumb :users_new do
  link "社員登録", new_admin_user_path
  parent :users_index
end

crumb :users_edit do |user,  admin_mode|
  link "社員編集", edit_admin_user_path(user)
  parent :users_show, user, admin_mode
end
