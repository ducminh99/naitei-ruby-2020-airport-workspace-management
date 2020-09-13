class DayOffFormat < Grape::Entity
  expose :data do
    expose :awol
    expose :leave
  end
  expose :message do |_users, options|
    options[:message]
  end
end
