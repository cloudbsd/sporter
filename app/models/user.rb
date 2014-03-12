class User < ActiveRecord::Base
  # the default scope first (if any)

  # attributes related macros

  # association macros
  has_and_belongs_to_many :groups
  belongs_to :debit
  has_many :transactions
  has_many :fees
  has_many :participants
  has_many :activities, through: :groups

  # validation macros
  validates :terms_of_service, :acceptance => true, on: :create
  validates :username, :presence => true, uniqueness: true, length: { in: 4..20 }

  # macros from gems

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  rolify

  # instance methods
  def become_owner group
    self.groups << group
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

  # class methods

end
