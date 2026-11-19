import { Controller } from "@hotwired/stimulus"
import Taggle from "taggle"

export default class extends Controller {
  connect() {
    // Turbo restores cached pages with the picker from the last visit.
    this.element.nextElementSibling?.classList.contains("keyword-picker-fake-input") &&
      this.element.nextElementSibling.remove()

    this.fakeInput = document.createElement("div")
    this.fakeInput.classList.add("keyword-picker-fake-input", ...this.element.classList)
    this.element.after(this.fakeInput)
    this.element.style.display = "none"

    this.taggle = new Taggle(this.fakeInput, {
      placeholder: this.element.getAttribute("placeholder"),
      tags: csvToArray(this.element.value),
      tabIndex: 0,
      saveOnBlur: true,
      onTagAdd: () => this.save(),
      onTagRemove: () => this.save()
    })

    const hint = document.querySelector(`label[for="${this.element.id}"] .form-hint`)
    if (hint) hint.textContent = "Type a comma, Return, or Enter to finish a keyword"
  }

  save() {
    this.element.value = arrayToCSV(this.taggle.getTagValues())
  }
}

function csvToArray(csv) {
  return csv.split(",")
    .filter((item) => item.trim() !== "")
    .map((item) => item.replace(/(^"|"$)/g, "").replace(/""/g, '"'))
}

function arrayToCSV(array) {
  return array.map((item) => {
    return /[\r\n,"]/.test(item) ? `"${item.replace(/"/g, '""')}"` : item
  }).join(",")
}
