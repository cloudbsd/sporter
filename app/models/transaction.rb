class Transaction < ActiveRecord::Base
  # the default scope first (if any)

  # constants
  TRANSACTION_TYPES = [ "deposit", "withdraw" ]

  # callbacks
  before_save do |txn|
    txn.amount = -txn.amount if txn.action == "withdraw"
  end

  # association macros
  belongs_to :user
  belongs_to :card
# has_one :participant

  # validation
  validates :amount, :presence => true, numericality: true
end
