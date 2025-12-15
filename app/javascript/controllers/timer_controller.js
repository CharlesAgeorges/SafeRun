import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    startedAt: String,
    pausedDuration: Number,
    paused: Boolean,
    duration: Number,
    overTimeUrl: String
  }

  connect() {
    this.overTimeAlertSent = false
    this.update()
    if (!this.pausedValue) {
      this.timer = setInterval(() => this.update(), 1000)
    }
  }

  disconnect() {
    clearInterval(this.timer)
  }

  update() {
    const totalSeconds = Math.floor((new Date() - new Date(this.startedAtValue)) / 1000)
    const runTime = totalSeconds - this.pausedDurationValue

    const h = Math.floor(runTime / 3600)
    const m = Math.floor((runTime % 3600) / 60)
    const s = runTime % 60
    this.element.textContent = `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
    this.checkOverTime(runTime)
  }

  checkOverTime(runTimeSeconds) {
    if (this.overTimeAlertSent || !this.hasDurationValue || !this.hasOverTimeUrlValue) return

    const plannedDurationSeconds = this.durationValue * 60
    const graceperiodSeconds = 60

    if (runTimeSeconds >= plannedDurationSeconds + graceperiodSeconds) {
      this.sendOverTimeAlert()
    }
  }

  sendOverTimeAlert() {
    this.overTimeAlertSent = true

    fetch(this.overTimeUrlValue, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Accept': 'text/vnd.turbo-stream.html'
      }
    })
  }
}
