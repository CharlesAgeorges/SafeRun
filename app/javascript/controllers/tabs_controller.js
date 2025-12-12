import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["runs", "guardians", "infos"]
  // connect() {
  //   console.log(this.hideTargets);
  // }
  toggle(event) {
    if (this.runsTargets.classList.contains("d-none")) {
      this.runsTargets.classList.remove("d-none")
      this.guardiansTarget.classList.add("d-none")
      this.infosTarget.classList.add("d-none")
    } else {
      this.runsTargets.classList.add("d-none")
      this.guardiansTarget.classList.remove("d-none")
      this.infosTarget.classList.remove("d-none")
    }
  }
}
