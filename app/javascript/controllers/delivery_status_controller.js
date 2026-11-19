import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["generic", "loading", "delivered", "reference"]
  static values = { url: String }

  connect() {
    this.runs = 0
    this.schedule()
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  schedule() {
    this.runs++

    if (this.runs > 5) {
      this.show(this.genericTarget)
      return
    }

    // Wait a little longer before each attempt to go easy on the server.
    this.timer = setTimeout(() => this.check(), 500 + (250 * this.runs))
  }

  async check() {
    const response = await fetch(this.urlValue, {
      headers: { Accept: "application/json" }
    })
    const { reference } = await response.json()

    if (!this.element.isConnected) return

    if (reference) {
      this.referenceTarget.textContent = reference
      this.show(this.deliveredTarget)
    } else {
      this.schedule()
    }
  }

  show(target) {
    this.loadingTarget.style.display = "none"
    target.style.display = "block"
  }
}
