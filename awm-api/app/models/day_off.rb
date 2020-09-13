class DayOff < ApplicationRecord
  belongs_to :user

  scope :filter_year, ->(year){where year: year}
  scope :filter_time, ->(year, month){where year: year, month: month}
  scope :sum_awol, ->{sum :awol}
  scope :sum_leave, ->{sum :leave}
end
