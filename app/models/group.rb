class Group < ActiveRecord::Base
  # constants
# PAYMENT_TYPES = [ "avg_yuan", "avg_jiao", "avg_fen", "with_card" ]
  PAYMENT_TYPES = [ ["avg_yuan", 1], ["avg_jiao", 2], ["avg_fen", 3], ["with_card", 4] ]

  # association macros
  has_and_belongs_to_many :users
  has_many :activities, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :transactions, through: :users
  has_many :card_types, dependent: :destroy

  # macros from gems
  resourcify

  # instance methods
  def owner
    User.with_role(:owner, self).first
  end

  def moderators
    User.with_role(:moderator, self)
  end
end
