class RedemptionSerializer < ActiveModel::Serializer
    attributes :id, :points_spent, :status, :created_at
    belongs_to :user
    belongs_to :reward
end
