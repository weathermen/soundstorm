import { Controller } from "stimulus"

export default class Translation extends Controller {
  static targets = ["response"]

  saved(event) {
    this.responseTarget.innerText = "Saved!"
  }

  failed(event) {
    this.responseTarget.innerText = "Error"
  }

  focus() {
  const elements = document.querySelectorAll(".translation--open")
  elements.forEach(element => {
    if (element !== this.element) {
      element.classList.remove("translation--open")
    }
  })


  }

  toggle(event) {
    this.focus()
    this.element.classList.toggle("translation--open")
  }
}
