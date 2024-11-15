module UsersHelper

  def working_status(user)
    user.working? ? '勤務中' : '勤務外'
  end

end