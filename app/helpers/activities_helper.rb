module ActivitiesHelper
  def activity_title activity
    "#{localize_date activity.started_at}, #{localize_time activity.started_at} - #{localize_time activity.stopped_at}"
  end

  def activity_link_to activity
    title = activity_title(activity)
    link_to title, [activity.group, activity]
  end

  class PayCalc
    def initialize activity
      @activity = activity
      @pay_count = @activity.participants.count
      @derated_pay = @activity.participants.sum('derated_pay')
    end

    def court_pay
      @activity.fee_items.sum('price')
    # @activity.court_pay
    end

    def derated_pay
      @derated_pay
    end

    def total_pay
      self.court_pay + self.derated_pay
    end

    def pay_count
      @pay_count
    end

    def average_pay
      if self.pay_count() == 0
        0
      else
        (self.total_pay + self.pay_count - 1) / self.pay_count
      end
    end

    def actual_pay
      self.average_pay * self.pay_count
    end
  end
end