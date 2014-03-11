class Activity < ActiveRecord::Base
  belongs_to :group
  has_many :fee_items, dependent: :destroy
  has_many :participants, dependent: :destroy

  def other_users
    self.group.users - self.participants.map(&:user)
  end
end
