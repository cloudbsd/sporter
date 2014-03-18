class CardType < ActiveRecord::Base
  belongs_to :group
  has_many :cards
end
