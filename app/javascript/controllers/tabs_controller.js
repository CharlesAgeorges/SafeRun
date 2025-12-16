import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["runs", "guardians", "infos", "earned", "available"]

  connect() {
    const hash = window.location.hash.replace("#", "")
    if (hash && this[`${hash}Targets`]) {
      this.showTab(hash)
    }
  }

  toggle(event) {
    const clickedTab = event.currentTarget.dataset.tabsTarget
    this.showTab(clickedTab)
  }

  showTab(tabName) {
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
    this.earnedTargets.forEach(el => {
      el.classList.remove("active")
      if (el.dataset.content) el.style.display = "none"
    })
    this.availableTargets.forEach(el => {
      el.classList.remove("active")
      if (el.dataset.content) el.style.display = "none"
    })

    // Active le bouton cliqué et affiche son contenu
    this[`${tabName}Targets`].forEach(el => {
      el.classList.add("active")
      el.classList.remove("d-none")
      if (el.dataset.content) el.style.display = "block"
    })
  }
}
