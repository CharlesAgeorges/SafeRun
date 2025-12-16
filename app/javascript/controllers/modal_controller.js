import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoOpen: Boolean }

  connect() {
    if (this.autoOpenValue) {
      // Utiliser Bootstrap depuis le global ou l'importer dynamiquement
      const Bootstrap = window.bootstrap
      if (Bootstrap && Bootstrap.Modal) {
        this.modal = new Bootstrap.Modal(this.element)
        this.modal.show()
      } else {
        // Fallback: import dynamique
        import("bootstrap").then((bootstrap) => {
          this.modal = new bootstrap.Modal(this.element)
          this.modal.show()
        })
      }
    }
  }
}
