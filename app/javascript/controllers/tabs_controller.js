import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["runs", "guardians", "infos"]
  // connect() {
  //   console.log(this.hideTargets);
  // }
    toggle(event) {
      const clickedTab = event.currentTarget.dataset.tabsTarget

      // Cache tous les contenus et désactive les boutons
      this.runsTargets.forEach(el => {
        el.classList.remove("active")
        if (el.dataset.content) el.style.display = "none"
      })
      this.guardiansTargets.forEach(el => {
        el.classList.remove("active")
        if (el.dataset.content) el.style.display = "none"
      })
      this.infosTargets.forEach(el => {
        el.classList.remove("active")
        if (el.dataset.content) el.style.display = "none"
      })

      // Active le bouton cliqué et affiche son contenu
      this[`${clickedTab}Targets`].forEach(el => {
        el.classList.add("active")
        if (el.dataset.content) el.style.display = "block"
      })
    }
}
