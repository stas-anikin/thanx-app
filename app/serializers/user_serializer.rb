class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :points_balance
end
