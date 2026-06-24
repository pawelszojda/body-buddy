import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "placeholder", "input", "filename"]

  connect() {
    this.objectUrl = null
  }

  disconnect() {
    this.revokeObjectUrl()
  }

  preview() {
    const [file] = this.inputTarget.files

    if (!file) {
      this.reset()
      return
    }

    this.revokeObjectUrl()
    this.objectUrl = URL.createObjectURL(file)

    this.imageTarget.src = this.objectUrl
    this.imageTarget.classList.remove("hidden")
    this.placeholderTarget.classList.add("hidden")
    this.filenameTarget.textContent = file.name
  }

  reset() {
    this.revokeObjectUrl()
    this.imageTarget.removeAttribute("src")
    this.imageTarget.classList.add("hidden")
    this.placeholderTarget.classList.remove("hidden")
    this.filenameTarget.textContent = "Brak wybranego pliku"
  }

  revokeObjectUrl() {
    if (this.objectUrl) {
      URL.revokeObjectURL(this.objectUrl)
      this.objectUrl = null
    }
  }
}
