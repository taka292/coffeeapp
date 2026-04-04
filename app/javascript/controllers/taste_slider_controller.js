import { Controller } from "@hotwired/stimulus"

// 味記録画面: 1〜10 のテイストスライダー（トラック表示とサム位置の同期）
export default class extends Controller {
  static targets = ["range", "fill", "thumb", "valueLabel"]

  connect() {
    this.sync()
  }

  sync() {
    const range = this.rangeTarget
    let v = parseInt(range.value, 10)
    const min = parseInt(range.min, 10)
    const max = parseInt(range.max, 10)
    if (Number.isNaN(v)) v = min
    v = Math.min(max, Math.max(min, v))
    range.value = String(v)

    const pct = max === min ? 0 : ((v - min) / (max - min)) * 100
    this.fillTarget.style.width = `${pct}%`
    this.thumbTarget.style.left = `${pct}%`
    this.valueLabelTarget.textContent = String(v)
    range.setAttribute("aria-valuenow", String(v))
  }
}
