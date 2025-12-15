
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { apiKey: String }
  static targets = ["input"]

  connect() {
    this.inputTarget.addEventListener("input", this.#onInput.bind(this))
    this.resultsContainer = document.createElement("div")
    this.resultsContainer.className = "autocomplete-results"
    this.inputTarget.parentNode.appendChild(this.resultsContainer)

    document.addEventListener("click", this.#onClickOutside.bind(this))

    // Récupérer la position de l'utilisateur
    this.userLocation = null
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          this.userLocation = {
            lng: position.coords.longitude,
            lat: position.coords.latitude
          }
        },
        () => {} // Ignorer les erreurs de géolocalisation
      )
    }
  }

  async #onInput(event) {
    const query = event.target.value
    if (query.length < 3) {
      this.#clearResults()
      return
    }

    let url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(query)}.json?access_token=${this.apiKeyValue}&types=country,region,place,postcode,locality,neighborhood,address`

    // Ajouter la proximité si disponible
    if (this.userLocation) {
      url += `&proximity=${this.userLocation.lng},${this.userLocation.lat}`
    }

    const response = await fetch(url)
    const data = await response.json()
    this.#displayResults(data.features)
  }

  #displayResults(features) {
    this.#clearResults()
    features.forEach(feature => {
      const item = document.createElement("div")
      item.className = "autocomplete-item"
      item.textContent = feature.place_name
      item.addEventListener("click", () => this.#selectResult(feature))
      this.resultsContainer.appendChild(item)
    })
  }

  #selectResult(feature) {
    this.inputTarget.value = feature.place_name
    this.#clearResults()
  }

  #clearResults() {
    this.resultsContainer.innerHTML = ""
  }

  #onClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.#clearResults()
    }
  }

  disconnect() {
    document.removeEventListener("click", this.#onClickOutside.bind(this))
  }
}
