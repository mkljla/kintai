module UsersHelper
  def working_status_icon(working_status)
    case working_status
    when "working"
      content_tag(:i, "", class: "bi bi-briefcase") # 勤務中のアイコン
    when "breaking"
      content_tag(:i, "", class: "bi bi-cup-hot") # 休憩中のアイコン
    when "not_working"
      content_tag(:i, "", class: "bi bi-house") # 勤務外のアイコン
    else
      content_tag(:i, "", class: "bi bi-question-circle") # 未登録のアイコン
    end
  end
end