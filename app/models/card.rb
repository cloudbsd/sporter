class Card < ActiveRecord::Base
  # the default scope first (if any)
  scope :debits, lambda { |group_id| joins(:card_type).where(:card_types => { kind: 'debit', group_id: group_id }) }
  scope :cashes, lambda { |group_id| joins(:card_type).where(:card_types => { kind: 'cash', group_id: group_id }) }
  scope :number_cards, lambda { |group_id| joins(:card_type).where(:card_types => { kind: 'number', group_id: group_id }) }
  scope :in_group, lambda { |group_id| joins(:card_type).where(:card_types => { group_id: group_id }) }
  scope :valid_cards, lambda { where("cards.number > ?", 0) }
  scope :up_to_date, lambda { where("cards.stopped_at > ?", DateTime.now.to_date) }

  # association macros
  belongs_to :user
  belongs_to :card_type
  has_many :participants
  has_many :transactions

  # callbacks
  before_save do |card|
    card.balance = 0 if is_period_card?
  end

  # instance methods
  def is_debit_card?
    self.card_type.is_debit_card?
  end

  def is_number_card?
    self.card_type.is_number_card?
  end

  def is_period_card?
    self.card_type.is_period_card?
  end

  def is_cash_card?
    self.card_type.is_cash_card?
  end

  def remaining_number
    if is_period_card?
      result = 0
    elsif is_cash_card?
      result = 0
    else
      result = self.balance + self.transactions.sum('amount') - self.participants.sum('net_pay')
    end
    if is_number_card? or is_period_card?
      result.to_i
    else
      result
    end
  end

  def in_date?
    self.stopped_at > DateTime.now.to_date
  end

  def is_valid?
    in_date? && (is_period_card? || remaining_number > 0)
  end
end
