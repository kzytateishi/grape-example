class MessageBoard < ActiveRecord::Base
  has_many :comments
end
