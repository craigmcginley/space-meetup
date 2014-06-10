class Comment < ActiveRecord::Base
  validates :body, length: {minimum: 1}

  belongs_to :event
  belongs_to :user
end
