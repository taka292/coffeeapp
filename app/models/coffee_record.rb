class CoffeeRecord < ApplicationRecord
  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  validates :bean_name, presence: true
  validates :grind_size, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :bean_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :water_temperature, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :brew_time, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :water_amount, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :brew_memo, length: { maximum: 2000 }, allow_blank: true
  validates :comment, length: { maximum: 2000 }, allow_blank: true
  validates :acidity, :bitterness, :sweetness, :body, :off_flavor,
            numericality: { only_integer: true, in: 1..10 }, allow_nil: true

  def brew_time_mmss
    t = brew_time.to_i
    format("%02d:%02d", t / 60, t % 60)
  end
end
