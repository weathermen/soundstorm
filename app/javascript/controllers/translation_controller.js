import { Controller } from "stimulus"

export default class Translation extends Controller {
  static targets = ["response"]

  saved(event) {
    this.responseTarget.innerText = "Saved!"
  }

  failed(event) {
    this.responseTarget.innerText = `Error: ${event.detail[2]}`
  }

  toggle(event) {
    this.element.classList.toggle("translation--open")
  }
}
