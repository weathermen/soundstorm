import { Controller } from "stimulus"

/**
 * Behavior for individual flash messages, like closing and timeouts.
 */
export default class FlashMessage extends Controller {
  connect() {
    if (this.type === "notice") {
      setTimeout(this.close, 15000)
    }
  }

  /**
   * Remove this flash message from the DOM
   */
  close(event) {
    if (event) {
      event.preventDefault()
    }

    this.element.classList.add("flash-message--closed")
    this.element.addEventListener("animationend", this.element.remove)
  }
}
