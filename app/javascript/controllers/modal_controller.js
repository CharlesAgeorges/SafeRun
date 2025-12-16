import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static values = { autoOpen: Boolean }

  connect() {
    if (this.autoOpenValue) {
      this.modal = new Modal(this.element)
      this.modal.show()
    }
  }
}
