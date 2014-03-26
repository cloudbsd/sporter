class CardType < ActiveRecord::Base
  # constants
# CARD_TYPES = [ {'cash', 'cash'} {'debit', 'debit'}, {'credit', 'credit'}, {'number', 'number'}, {'period', 'period'} ]
  CARD_TYPES = [ 'cash', 'debit', 'number', 'period' ]

  # association macros
  belongs_to :group
  has_many :cards
  has_many :transactions, through: :cards

  # validation
  validates :group_id, :presence => true
  validates :name, :presence => true
  validates :kind, :presence => true
  validates :price, :presence => true

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

  def is_cash_card?
    self.kind == 'cash'
  end

  # class methods
  def self.find_or_create_debit_type group_id
    card_type = CardType.find_by(group_id: group_id, kind: 'debit')
    if card_type.nil?
      card_type = CardType.create!(group_id: group_id, kind: 'debit', name: I18n.translate('card_types.type.debit'), price: 0, duration: 0, number: 0)
    end
    card_type
  end

  def self.find_or_create_cash_type group_id
    card_type = CardType.find_by(group_id: group_id, kind: 'cash')
    if card_type.nil?
      card_type = CardType.create!(group_id: group_id, kind: 'cash', name: I18n.translate('card_types.type.cash'), price: 0, duration: 0, number: 1)
    end
    card_type
  end
end
