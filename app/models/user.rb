class User < ActiveRecord::Base
  # the default scope first (if any)

  # constants
  GENDER = [ ['secrecy', 's'], ['man', 'm'], ['woman', 'w'] ]

  # attributes related macros

  # association macros
  has_and_belongs_to_many :groups
  has_many :transactions
  has_many :fees
  has_many :participants
  has_many :activities, through: :groups
  has_many :cards, dependent: :destroy

  # validation macros
  validates :terms_of_service, :acceptance => true, on: :create
# validates :username, :presence => true, uniqueness: true, length: { in: 4..20 }

  # macros from gems

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  rolify

  # callbacks
  after_create do |user|
    if user.gravatar.nil?
      gravatar = format "user%03d.jpg", user.id%29+1
      user.update(gravatar: gravatar)
    end
  # card_type = CardType.find_or_create_by!(group_id: group_id, kind: 'cash', name: I18n.translate('card_types.type.cash'))
  # cards.create!(card_type_id: card_type.id, started_at: Date.today, balance: 0)
  end

  # instance methods
  def admin?
    self.has_role? :admin
  end

  def become_owner group
  # self.groups << group if self.groups.include? group
    group.users << self unless group.users.include?(self)
    self.add_role :owner, group
  end

  def become_moderator group
    self.add_role :moderator, group
  end

  def is_owner? group
    self.has_role? :owner, group
  end

  def is_moderator? group
    self.has_role? :moderator, group
  end

  def owned_groups
    Group.with_roles(:owner, self)
  end

  def managed_groups
    Group.with_roles(:moderator, self)
  end

  def find_or_create_debit_card!(group_id)
    debit_cards = self.cards.debits(group_id)
    if debit_cards.empty?
      card_type = CardType.find_or_create_debit_type(group_id)
      debit = self.cards.create!(card_type_id: card_type.id, started_at: Date.today, balance: 0)
    else
      debit = debit_cards.first
    end
    debit
  end

  def find_or_create_cash_card!(group_id)
    cash_cards = self.cards.cashes(group_id)
    if cash_cards.empty?
      card_type = CardType.find_or_create_cash_type(group_id)
      cash_card = self.cards.create!(card_type_id: card_type.id, started_at: Date.today, balance: 0)
    else
      cash_card = cash_cards.first
    end
    cash_card
  end

  # class methods

end
