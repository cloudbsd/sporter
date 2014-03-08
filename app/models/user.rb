class User < ActiveRecord::Base
  # the default scope first (if any)

  # attributes related macros

  # association macros
  has_and_belongs_to_many :groups

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

  # class methods

end
