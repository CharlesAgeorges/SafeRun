import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { startedAt: String }

  connect() {
    this.timer = setInterval(() => this.update(), 1000)
    this.update()
  }

  disconnect() {
    clearInterval(this.timer)
  }

  update() {
    const seconds = Math.floor((new Date() - new Date(this.startedAtValue)) / 1000)
    const h = Math.floor(seconds / 3600)
    const m = Math.floor((seconds % 3600) / 60)
    const s = seconds % 60
    this.element.textContent = `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
  }
}
