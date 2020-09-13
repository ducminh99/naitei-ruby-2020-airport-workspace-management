class RequestStatisticFormat < Grape::Entity
  expose :data do
    expose :approved
    expose :rejected
  end
  expose :message do |_users, options|
    options[:message]
  end
end
