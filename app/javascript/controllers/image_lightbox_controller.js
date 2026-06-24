import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "image", "label"]

  open(event) {
    const trigger = event.currentTarget
    const src = trigger.dataset.fullSrc
    const label = trigger.dataset.label

    if (!src) return

    this.imageTarget.src = src
    this.imageTarget.alt = label || "Podgląd zdjęcia"
    this.labelTarget.textContent = label || "Zdjęcie"

    if (!this.dialogTarget.open) {
      this.dialogTarget.showModal()
    }
  }

  close() {
    this.dialogTarget.close()
    this.reset()
  }

  reset() {
    this.imageTarget.removeAttribute("src")
  }

  closeOnBackdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}
