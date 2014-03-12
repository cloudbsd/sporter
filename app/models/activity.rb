class Activity < ActiveRecord::Base
  # the default scope first (if any)
  scope :inoneweek, lambda { where("activities.started_at <= ?", 1.week.since.to_date) }

  # association macros
  belongs_to :group
  has_many :fee_items, dependent: :destroy
  has_many :participants, dependent: :destroy

  # instance methods
  def other_users
    self.group.users - self.participants.map(&:user)
  end
end
