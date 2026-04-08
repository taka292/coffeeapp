module CoffeeRecordsHelper
  # 初回記録時（直前の保存がない）のフォーム用・レンジ中央付近の値
  NEUTRAL_GRIND_SIZE = 25
  NEUTRAL_BEAN_AMOUNT = 20
  NEUTRAL_WATER_TEMPERATURE = 90
  NEUTRAL_WATER_AMOUNT = 200
  NEUTRAL_BREW_TIME_SECONDS = 150 # 2:30

  # 抽出条件フォームの表示用値
  # - 新規かつエラーなし: 直前レコード由来の属性があればそれを使い、なければ中央付近の値
  # - バリデーションエラー時: 入力値を優先（未入力は中央付近で表示）
  def brew_setup_form_values(coffee_record)
    new_clean = coffee_record.new_record? && coffee_record.errors.empty?
    brew_time_total = derive_brew_time_total_seconds(coffee_record, new_clean)

    {
      grind_size: pick_brew_numeric(coffee_record.grind_size, new_clean, NEUTRAL_GRIND_SIZE),
      bean_amount: pick_brew_numeric(coffee_record.bean_amount, new_clean, NEUTRAL_BEAN_AMOUNT),
      water_temperature: pick_brew_numeric(coffee_record.water_temperature, new_clean, NEUTRAL_WATER_TEMPERATURE),
      water_amount: pick_brew_numeric(coffee_record.water_amount, new_clean, NEUTRAL_WATER_AMOUNT),
      brew_time: brew_time_total
    }
  end

  # 味スライダー（1〜10）の表示値。nil のときは中央の 5
  def taste_balance_display_values(record)
    slide = ->(v) { v.nil? ? 5 : v }
    {
      acidity: slide.call(record.acidity),
      bitterness: slide.call(record.bitterness),
      sweetness: slide.call(record.sweetness),
      body: slide.call(record.body),
      off_flavor: slide.call(record.off_flavor)
    }
  end

  private

  def derive_brew_time_total_seconds(record, new_clean)
    return record.brew_time.to_i if record.brew_time.present?

    new_clean ? NEUTRAL_BREW_TIME_SECONDS : 0
  end

  def pick_brew_numeric(value, new_clean, neutral)
    return value if value.present?
    return neutral if new_clean

    neutral
  end
end
