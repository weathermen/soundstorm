import { Controller } from "stimulus"

export default class Flash extends Controller {
  /**
   * Remove this flash message from the DOM
   */
  close(event) {
    event.preventDefault()
    this.element.remove()
  }
}
