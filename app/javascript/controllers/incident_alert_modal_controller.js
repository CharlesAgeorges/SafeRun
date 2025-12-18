import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("show.bs.modal", this.sendAlert.bind(this))
  }

  sendAlert(event) {
    const button = event.relatedTarget
    if (button) {
      const url = button.getAttribute("data-incident-alert-url")
      if (url) {
        fetch(url, {
          method: "POST",
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            "Accept": "application/json"
          }
        })
      }
    }
  }
}
