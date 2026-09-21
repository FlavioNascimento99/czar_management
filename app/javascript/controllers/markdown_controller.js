import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]
  static values = { url: String }

  connect() {
    this.timer = null
    this.render()
  }

  changed() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.render(), 400)
  }

  async render() {
    const token = document.querySelector('meta[name="csrf-token"]')?.content
    try {
      const res = await fetch(this.urlValue, {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-CSRF-Token": token },
        body: JSON.stringify({ body: this.inputTarget.value })
      })
      if (res.ok) this.previewTarget.innerHTML = await res.text()
    } catch {
      /* mantém último preview */
    }
  }
}
