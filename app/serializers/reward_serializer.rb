class RewardSerializer < ActiveModel::Serializer
    attributes :id, :name, :description, :points_cost, :is_active
end
