class Activity < ActiveRecord::Base
  # the default scope first (if any)
  scope :oneweek, lambda { where("activities.stopped_at > ? AND activities.stopped_at < ?", DateTime.now, 1.week.since) }
  scope :recents, lambda { where("activities.stopped_at > ?", DateTime.now) }
  scope :outdated, lambda { where("activities.stopped_at <= ?", DateTime.now) }

  # association macros
  belongs_to :group
  has_many :fee_items, dependent: :destroy
  has_many :participants, dependent: :destroy

  # instance methods
  def outdated?
    self.stopped_at < DateTime.now
  end

  def enrolled_by? user
    participants.map(&:user).include? user
  end

  def full_title
    if title.present?
      title
    else
      full_time
    end
  end

  def full_time
    "#{self.started_at.strftime(I18n.t(:"datetime.formats.date"))}, #{self.started_at.strftime(I18n.t(:"datetime.formats.time"))} - #{self.stopped_at.strftime(I18n.t(:"datetime.formats.time"))}"
  end

  def full_place
    p = Province.find_by(code: province)
    province_name = p.name if p.present?
    c = City.find_by(code: city)
    city_name = c.name if c.present?
    d = District.find_by(code: district)
    district_name = d.name if d.present?
    "#{province_name} #{city_name} #{district_name} #{location}"
  end

  def started_weekday
    days = I18n.t('date.day_names')
    i = started_at.strftime("%w").to_i
    days[i]
  end

  def pay_with_card?
    self.pay_type == Group::PAY_WITH_CARD
  end

  def other_users cur
    self.group.users - (self.participants.map(&:user) - [cur])
  end

  def generate_bill
    if self.pay_type != Group::PAY_WITH_CARD
      pay_count = participants.count + participants.sum('friend_number')
      if pay_count > 0
        item_pay = fee_items.sum('price')
        derated_pay = participants.sum('derated_pay')
        total_pay = item_pay + derated_pay
        average_pay = (total_pay.to_i + pay_count - 1) / pay_count
        actual_pay = average_pay * pay_count
        participants.each do |participant|
          participant.net_pay = average_pay*(participant.friend_number + 1) - participant.derated_pay
          participant.save
        end # each
      end # if
    else
      participants.each do |participant|
        if participant.card.is_debit_card? or participant.card.is_cash_card?
          participant.net_pay = self.group.price
        else
          participant.net_pay = participant.friend_number + 1
        end
        participant.save
      end # each
    end # if
  end

# def confiscation
#   pay_count = participants.count
#   remainder_pay = 0
#   if pay_count > 0
#     derated_pay = participants.sum('derated_pay')
#     total_pay = item_pay + derated_pay
#     average_pay = (total_pay + pay_count - 1) / pay_count
#     actual_pay = average_pay * pay_count
#     remainder_pay = actual_pay - total_pay
#   end
#   remainder_pay
# end
end
