import { Controller } from "stimulus"

export default class Flash extends Controller {
  initialize() {
    document.addEventListener("ajax:complete", this.render)
  }

  /**
   * Remove this flash message from the DOM
   */
  close(event) {
    event.preventDefault()
    this.element.remove()
  }
}
