import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["confirmBtn"]

  connect() {
    this.element.addEventListener("show.bs.modal", this.updateUrl.bind(this))
  }

  updateUrl(event) {
    const button = event.relatedTarget
    if (button) {
      const url = button.getAttribute("data-end-run-url")
      if (url && this.hasConfirmBtnTarget) {
        this.confirmBtnTarget.setAttribute("href", url)
      }
    }
  }
}
