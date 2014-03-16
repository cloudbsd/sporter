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
      @pay_count = @activity.participants.count + @activity.participants.sum('friend_number')
      @item_pay = @activity.fee_items.sum('price')
      @derated_pay = @activity.participants.sum('derated_pay')
    end

    def items_pay
      @item_pay
    end

    def derated_pay
      @derated_pay
    end

    def total_pay
      items_pay() + derated_pay()
    end

    def pay_count
      @pay_count
    end

    def average_pay
      if pay_count() == 0
        0
      else
        (total_pay().to_i + pay_count() - 1) / pay_count()
      end
    end

    def actual_pay
      average_pay() * pay_count()
    end

    def confiscation
      pay_count == 0 ? 0 : (actual_pay() - total_pay())
    end
  end
end
