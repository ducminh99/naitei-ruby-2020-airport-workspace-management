class StatisticFormat < Grape::Entity
  expose :id
  expose :email
  expose :name
  expose :awol
  expose :leave
  expose :approved
  expose :rejected
end
