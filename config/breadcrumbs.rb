crumb :home_users do
  link "Home", home_users_path
end

crumb :admin_home do
  link "Home", admin_users_path
end

crumb :user_new do
  link "ユーザー登録", new_user_path
  parent :admin_users_path
end

# 以下にコードを追加する
crumb :user_show do
  link "ユーザー詳細", user_path(current_user.id)
  parent :home_users
end

crumb work_show do
  link "勤務詳細", user_path(@work.id)
  parent :home_users
end

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