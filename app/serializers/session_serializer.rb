class SessionSerializer < ActiveModel::Serializer
  attributes :username, :user
  type :sessions

  def user
    return object.id
  end

  def id
    return object.token
  end
end
