class CoffeeRecord < ApplicationRecord
  belongs_to :user

  attr_accessor :brew_minute, :brew_second
  before_validation :assign_brew_time_from_parts

  validates :bean_name, presence: true
  validates :grind_size, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :bean_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :water_temperature, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :brew_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :water_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :brew_memo, length: { maximum: 2000 }, allow_blank: true
  validates :comment, length: { maximum: 2000 }, allow_blank: true

  def brew_time_mmss
    t = brew_time.to_i
    format("%02d:%02d", t / 60, t % 60)
  end

  private

  def assign_brew_time_from_parts
    return if brew_minute.blank? && brew_second.blank?

    minute = [brew_minute.to_i, 0].max
    second = brew_second.to_i.clamp(0, 59)
    self.brew_time = (minute * 60) + second
  end
end
