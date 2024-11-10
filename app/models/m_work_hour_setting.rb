class MWorkHourSetting < ApplicationRecord
  def self.standard_work_in_minutes
    first&.standard_working_time_minutes*60 || 0
  end
end
