import { Controller } from "@hotwired/stimulus"

// 抽出記録画面: 挽き目スライダー・比率表示・抽出時間（秒入力）
export default class extends Controller {
  static targets = [
    "grindRange",
    "grindValue",
    "grindFill",
    "grindHint",
    "grindPill",
    "beanAmount",
    "waterAmount",
    "ratioLine",
    "brewTime",
    "brewTimeDisplay",
  ]

  connect() {
    this.updateGrind()
    this.updateRatio()
    this.updateBrewTimeDisplay()
  }

  grindChanged() {
    this.updateGrind()
  }

  updateGrind() {
    const v = parseInt(this.grindRangeTarget.value, 10)
    const pct = ((v - 1) / 49) * 100
    this.grindFillTarget.style.width = `${pct}%`
    this.grindValueTarget.textContent = String(v)
    this.grindPillTarget.textContent = `${v} / 50`
    this.grindHintTarget.textContent = this.grindHintFor(v)
  }

  grindHintFor(v) {
    if (v <= 16) return "細挽きに近い設定"
    if (v <= 33) return "中細挽きに近い設定"
    if (v <= 42) return "中挽きに近い設定"
    return "粗挽きに近い設定"
  }

  ratioChanged() {
    this.updateRatio()
  }

  updateRatio() {
    const g = parseFloat(this.beanAmountTarget.value)
    const ml = parseFloat(this.waterAmountTarget.value)
    if (g > 0 && ml > 0) {
      const r = (ml / g).toFixed(1)
      this.ratioLineTarget.textContent = `${g}g : ${ml}ml で約1:${r}`
    } else {
      this.ratioLineTarget.textContent = "豆の量と湯量を入力すると表示されます"
    }
  }

  brewTimeChanged() {
    this.updateBrewTimeDisplay()
  }

  updateBrewTimeDisplay() {
    let total = parseInt(this.brewTimeTarget.value, 10)
    if (Number.isNaN(total)) total = 0
    total = Math.max(0, total)
    this.brewTimeTarget.value = total
    const mm = String(Math.floor(total / 60)).padStart(2, "0")
    const ss = String(total % 60).padStart(2, "0")
    const label = `${mm}:${ss}`
    if (this.hasBrewTimeDisplayTarget) {
      this.brewTimeDisplayTarget.textContent = label
    }
  }
}
