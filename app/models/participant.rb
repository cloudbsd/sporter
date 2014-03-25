class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity
  belongs_to :card
  belongs_to :transaction, dependent: :destroy

  # callbacks
  before_save do |participant|
    participant.net_pay = participant.friend_number + 1
  end

  after_save do |participant|
  # activity.generate_bill
  end

  after_destroy do |participant|
  # activity.generate_bill
  end

  # validation
  validates :user_id, :presence => true, numericality: true
  validates :activity_id, :presence => true, numericality: true
  validates :friend_number, :presence => true, numericality: true
  validates :derated_pay, :presence => true

# # instance methods
# def pay_with_card card
#   card.number -= 1 + self.friend_number
#   card.save!
# end

  def remaining_number
    card.nil? ? 0 : card.remaining_number
  end

  def consume_number
    if card.is_debit_card?
      amount = self.net_pay
    elsif card.is_number_card?
      amount = 1 + self.friend_number
    elsif card.is_period_card?
      amount = 0
    end
    amount
  end

# def create_or_update_transaction
#   if card.is_debit_card?
#     amount = self.net_pay
#   elsif card.is_number_card?
#     amount = 1 + self.friend_number
#   elsif card.is_period_card?
#     amount = 0
#   end
#   if transaction.nil?
#     self.create_transaction(user_id: self.user_id, card_id: card_id, action: 'withdraw', amount: amount, operated_at: self.activity.started_at.to_date)
#   else
#     self.transaction.update(user_id: self.user_id, card_id: card_id, action: 'withdraw', amount: amount, operated_at: self.activity.started_at.to_date)
#   end
# end
end
