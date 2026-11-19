import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["url", "title", "summary", "preview"]

  connect() {
    this.update()
  }

  update() {
    const preview = this.previewTarget

    preview.querySelector(".js-suggestion-link").href = this.urlTarget.value || "#"
    preview.querySelector(".js-suggestion-title").textContent = this.titleTarget.value || "[no title]"
    preview.querySelector(".js-suggestion-summary").textContent = this.summaryTarget.value
  }
}
