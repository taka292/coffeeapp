module ApplicationHelper
  # 1〜10 の味スコアを縦バーの高さ%に変換（nil は 0）
  def taste_bar_height_percent(value)
    return 0 if value.blank?

    v = value.to_i.clamp(0, 10)
    (v / 10.0 * 100).round
  end
end
