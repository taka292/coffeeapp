import { Controller } from "@hotwired/stimulus"

// 記録一覧: カードタップで編集・削除用のボトムシートを表示
export default class extends Controller {
  static targets = ["root", "editLink", "deleteLink"]

  connect() {
    this.onEscape = this.onEscape.bind(this)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onEscape)
    document.body.classList.remove("overflow-hidden")
  }

  open(event) {
    if (event.type === "keydown") {
      if (event.key === " ") event.preventDefault()
      if (event.key !== "Enter" && event.key !== " ") return
    }

    const el = event.currentTarget
    const editUrl = el.getAttribute("data-record-action-sheet-edit-url")
    const deleteUrl = el.getAttribute("data-record-action-sheet-delete-url")
    const name = el.getAttribute("data-record-action-sheet-record-name") || "この記録"

    if (!editUrl || !deleteUrl) return

    this.editLinkTarget.href = editUrl
    this.deleteLinkTarget.href = deleteUrl
    this.deleteLinkTarget.dataset.turboConfirm = `「${name}」を削除しますか？この操作は取り消せません。`

    this.rootTarget.classList.remove("hidden")
    this.rootTarget.setAttribute("aria-hidden", "false")
    document.body.classList.add("overflow-hidden")
    document.addEventListener("keydown", this.onEscape)
    queueMicrotask(() => this.editLinkTarget.focus())
  }

  close() {
    this.rootTarget.classList.add("hidden")
    this.rootTarget.setAttribute("aria-hidden", "true")
    document.body.classList.remove("overflow-hidden")
    document.removeEventListener("keydown", this.onEscape)
    this.editLinkTarget.href = "#"
    this.deleteLinkTarget.href = "#"
    this.deleteLinkTarget.removeAttribute("data-turbo-confirm")
  }

  onEscape(event) {
    if (event.key === "Escape") this.close()
  }
}
