class Attendee < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: { scope: :event_id, message: "You've already joined!"}

  belongs_to :user
  belongs_to :event
end
