import { Controller } from "@hotwired/stimulus"
import mapboxgl from 'mapbox-gl'

export default class extends Controller {

  static values = {
    apiKey: String,
    markers: Array,
    runId: Number,
    positions: Array
  }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.routeCoordinates = this.positionsValue.map(position => [position.lng, position.lat])
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.map.on('load', () => {
      this.#addRouteLine()
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#addGeolocateControl()
  }


  #addGeolocateControl() {
    const geolocate = new mapboxgl.GeolocateControl({
      positionOptions: { enableHighAccuracy: true },
      trackUserLocation: true,
      showUserHeading: true
    })

    this.map.addControl(geolocate)

    geolocate.on('geolocate', (e) => {
      const lng = e.coords.longitude
      const lat = e.coords.latitude
      this.#addPointToRoute(lng, lat)
    })
  }

  #addRouteLine() {
    this.map.addSource('route', {
      type: 'geojson',
      data: {
        type: 'Feature',
        properties: {},
        geometry: {
          type: 'LineString',
          coordinates: this.routeCoordinates
        }
      }
    })

    this.map.addLayer({
      id: 'route',
      type: 'line',
      source: 'route',
      layout: {
        'line-join': 'round',
        'line-cap': 'round'
      },
      paint: {
        'line-color': '#1b146fff',
        'line-width': 5
      }
    })
  }

  #addPointToRoute(lng, lat) {
    this.routeCoordinates.push([lng, lat])
    this.map.getSource('route').setData({
      type: 'Feature',
      properties: {},
      geometry: {
        type: 'LineString',
        coordinates: this.routeCoordinates
      }
    })

    this.#savePosition(lat, lng)
  }

  #savePosition(lat, lng) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(`/runs/${this.runIdValue}/positions`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        position: { latitude: lat, longitude: lng }
      })
    })
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const mapMarker = new mapboxgl.Marker({ color: "#000000" })
        .setLngLat([marker.lng, marker.lat])
        .addTo(this.map)

      if (marker.info_window_html) {
        const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)
        mapMarker.setPopup(popup)
      }
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker => bounds.extend([marker.lng, marker.lat]))
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }
}
