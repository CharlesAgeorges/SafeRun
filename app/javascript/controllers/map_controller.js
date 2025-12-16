import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    runId: Number,
    positions: Array,
    status: String
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.rawCoordinates = this.positionsValue.map(p => [p.lng, p.lat])

    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.map.on("load", async () => {
      this.#addRouteLine()
      if (this.rawCoordinates.length >= 2) {
        await this.#matchRoute()
      }
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#setupGeolocate()
  }

  #setupGeolocate() {
    this.geolocate = new mapboxgl.GeolocateControl({
      positionOptions: { enableHighAccuracy: true },
      trackUserLocation: true,
      showUserHeading: true
    })

    this.map.addControl(this.geolocate)

    this.geolocate.on("geolocate", (e) => {
      if (this.statusValue === "running") {
        this.#addPointToRoute(e.coords.longitude, e.coords.latitude)
      }
    })

    if (this.statusValue === "running") {
      this.map.on("load", () => {
        this.geolocate.trigger()
      })
    }
  }

  #addRouteLine() {
    this.map.addSource("route", {
      type: "geojson",
      data: {
        type: "Feature",
        properties: {},
        geometry: { type: "LineString", coordinates: this.rawCoordinates }
      }
    })

    this.map.addLayer({
      id: "route",
      type: "line",
      source: "route",
      layout: { "line-join": "round", "line-cap": "round" },
      paint: { "line-color": "#1b146f", "line-width": 5 }
    })
  }

  #addPointToRoute(lng, lat) {
    this.rawCoordinates.push([lng, lat])
    this.#savePosition(lat, lng)
    this.#matchRoute()
  }

  #savePosition(lat, lng) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(`/runs/${this.runIdValue}/positions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ position: { latitude: lat, longitude: lng } })
    })
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const mapMarker = new mapboxgl.Marker({ color: "#000000" })
        .setLngLat([marker.lng, marker.lat])
        .addTo(this.map)

      if (marker.info_window_html) {
        mapMarker.setPopup(new mapboxgl.Popup().setHTML(marker.info_window_html))
      }
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  async #matchRoute() {
    if (this.rawCoordinates.length < 2) return

    const geometry = await this.#getMatchedGeometry(this.rawCoordinates)
    if (geometry) {
      this.map.getSource("route").setData({
        type: "Feature",
        properties: {},
        geometry: geometry
      })
    }
  }

  async #getMatchedGeometry(coordinates) {
    const coordsString = coordinates.map(c => c.join(",")).join(";")
    const radiuses = coordinates.map(() => 50).join(";")
    const url = `https://api.mapbox.com/matching/v5/mapbox/walking/${coordsString}?geometries=geojson&radiuses=${radiuses}&overview=full&access_token=${mapboxgl.accessToken}`

    try {
      const response = await fetch(url)
      const data = await response.json()

      if (data.code === "Ok" && data.matchings?.length > 0) {
        return data.matchings[0].geometry
      }
      console.warn("[Map Matching]", data.code, data.message)
      return null
    } catch (error) {
      console.error("[Map Matching]", error)
      return null
    }
  }
}
