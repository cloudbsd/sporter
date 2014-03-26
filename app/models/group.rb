class Group < ActiveRecord::Base
  # constants
# PAYMENT_TYPES = [ "avg_yuan", "avg_jiao", "avg_fen", "with_card" ]
  PAYMENT_TYPES = [ ["avg_yuan", 'Y'], ["avg_jiao", 'J'], ["avg_fen", 'F'], ["with_card", 'C'] ]
  PAY_WITH_CARD = 'C'

  # association macros
  has_and_belongs_to_many :users
  has_many :activities, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :card_types, dependent: :destroy
# has_many :cards, through: :users
# has_many :transactions, through: :users
  has_many :cards, through: :card_types
  has_many :transactions, through: :cards

  # macros from gems
  resourcify

  # instance methods
  def owner
    User.with_role(:owner, self).first
  end

  def moderators
    User.with_role(:moderator, self)
  end

  def pay_with_card?
    self.pay_type == PAY_WITH_CARD
  end

  def add_member user
    users << user unless users.include? user
  # user.find_or_create_cash_card! self.id
  end
end
