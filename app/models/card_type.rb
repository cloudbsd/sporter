class CardType < ActiveRecord::Base
  # constants
# CARD_TYPES = [ {'cash', 'cash'} {'debit', 'debit'}, {'credit', 'credit'}, {'number', 'number'}, {'period', 'period'} ]
  CARD_TYPES = [ 'cash', 'debit', 'number', 'period' ]

  # association macros
  belongs_to :group
  has_many :cards
end
