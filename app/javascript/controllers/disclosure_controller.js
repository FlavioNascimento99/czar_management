import { Controller } from "@hotwired/stimulus"

// Toggles a panel from a button (menus, mobile nav). Closes on Escape and outside click.
export default class extends Controller {
  static targets = ["button", "panel"]

  connect() {
    this.closeOnOutsideClick = this.closeOnOutsideClick.bind(this)
  }

  disconnect() {
    this.close()
  }

  toggle() {
    this.expanded ? this.close() : this.open()
  }

  open() {
    this.panelTarget.hidden = false
    this.buttonTarget.setAttribute("aria-expanded", "true")
    document.addEventListener("click", this.closeOnOutsideClick)
  }

  close() {
    this.panelTarget.hidden = true
    this.buttonTarget.setAttribute("aria-expanded", "false")
    document.removeEventListener("click", this.closeOnOutsideClick)
  }

  closeOnEscape(event) {
    if (!this.expanded) return
    event.stopPropagation()
    this.close()
    this.buttonTarget.focus()
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  get expanded() {
    return this.buttonTarget.getAttribute("aria-expanded") === "true"
  }
}
