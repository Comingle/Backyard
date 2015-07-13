class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :avatar, :username
end
