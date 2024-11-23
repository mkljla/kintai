crumb :users_home do
  link "Home", home_users_path
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

# admin
crumb :admin_users_index do
  link "社員一覧", admin_users_path
end

crumb :admin_users_show do |user|
  link "社員詳細", admin_user_path(user)
  parent :admin_users_index
end

crumb :admin_users_new do
  link "社員登録", new_admin_user_path
  parent :admin_users_index
end

crumb :admin_users_edit do |user|
  link "社員編集", edit_admin_user_path(user)
  parent :admin_users_index
end
# crumb admin_users_index do
#   link "勤務詳細", admin_users_path
#   parent :admin/users/index
# end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).