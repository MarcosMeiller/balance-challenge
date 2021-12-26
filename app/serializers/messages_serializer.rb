class MessagesSerializer < ActiveModel::Serializer
  attributes :id,:content,:is_balanced
end
