class Person < Sequel::Model
  one_to_many :subscriptions
  one_to_many :notifications

  def do_not_disturb?
    local_hour >= do_not_disturb_start && local_hour < do_not_disturb_stop
  end

  def local_hour
    @local_hour ||= Time.now.getlocal("#{sign}#{"%02d:00" % abs_local}").strftime("%H").to_i
  end

  private

  def sign
    time_offset.positive? ? "" : "-"
  end

  def abs_local
    time_offset.abs
  end

  def do_not_disturb_start
    0
  end
  def do_not_disturb_stop
    7
  end
end
