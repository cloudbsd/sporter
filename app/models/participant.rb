class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :card

  # callbacks
# before_create do |participant|
# # user.add_role :stacker if user.roles.empty?
# end

# after_destroy do |participant|
#   card = participant.card
#   unless card.nil?
#     card.number += 1 + participant.friend_number
#     card.save!
#   end
# end

# # instance methods
# def pay_with_card card
#   card.number -= 1 + self.friend_number
#   card.save!
# end

  def remaining_number
    card.nil? ? 0 : card.remaining_number
  end
end
