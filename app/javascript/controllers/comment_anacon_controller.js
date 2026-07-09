import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  insert(event) {
    const token = event.currentTarget.dataset.anaconToken
    if (!token || !this.hasInputTarget) return

    const input = this.inputTarget
    const start = input.selectionStart ?? input.value.length
    const end = input.selectionEnd ?? input.value.length
    const prefix = input.value.slice(0, start)
    const suffix = input.value.slice(end)
    const spacer = prefix && !prefix.endsWith(" ") && !prefix.endsWith("\n") ? " " : ""

    input.value = `${prefix}${spacer}${token} ${suffix}`
    input.focus()
    input.selectionStart = input.selectionEnd = start + spacer.length + token.length + 1
  }
}
