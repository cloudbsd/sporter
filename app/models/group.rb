class Group < ActiveRecord::Base
  # association macros
  has_and_belongs_to_many :users
  has_many :activities, dependent: :destroy
  has_many :fees, dependent: :destroy
  has_many :transactions, through: :users

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
