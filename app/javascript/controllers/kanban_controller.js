import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["column"]

  dragStart(event) {
    const card = event.target.closest("[data-task-id]")
    if (!card) return
    event.dataTransfer.setData("text/plain", card.dataset.taskId)
    event.dataTransfer.effectAllowed = "move"
  }

  dragOver(event) {
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
  }

  async drop(event) {
    event.preventDefault()
    const column = event.target.closest("[data-status]")
    const taskId = event.dataTransfer.getData("text/plain")
    if (!column || !taskId) return

    const status = column.dataset.status
    const url = `${this.element.dataset.updateBase}/${taskId}`
    const token = document.querySelector('meta[name="csrf-token"]')?.content

    try {
      const res = await fetch(url, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": token
        },
        body: JSON.stringify({ task: { status } })
      })
      if (!res.ok) throw new Error(`HTTP ${res.status}`)
      const card = this.element.querySelector(`[data-task-id="${taskId}"]`)
      column.querySelector("[data-cards]").prepend(card)
    } catch {
      alert("Não foi possível mover a tarefa. Tente novamente.")
    }
  }
}
