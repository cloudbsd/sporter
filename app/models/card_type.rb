class CardType < ActiveRecord::Base
  # constants
# CARD_TYPES = [ {'cash', 'cash'} {'debit', 'debit'}, {'credit', 'credit'}, {'number', 'number'}, {'period', 'period'} ]
  CARD_TYPES = [ 'cash', 'debit', 'number', 'period' ]

  # association macros
  belongs_to :group
  has_many :cards
  has_many :transactions, through: :cards

  # instance methods
  def is_debit_card?
    self.kind == 'debit'
  end

  def is_number_card?
    self.kind == 'number'
  end

  def is_period_card?
    self.kind == 'period'
  end

end
