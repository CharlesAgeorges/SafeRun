import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["runs", "guardians", "infos"]
  // connect() {
  //   console.log(this.hideTargets);
  // }
    toggle() {
      
    }
}
