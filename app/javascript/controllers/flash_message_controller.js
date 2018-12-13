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
   * Fade the flash message out when the "close" button is clicked. This
   * triggers an animation that eventually calls the #remove event.
   */
  close(event) {
    if (event) {
      event.preventDefault()
    }

    this.element.classList.add("flash-message--closed")
  }

  /**
   * Remove the flash message from the DOM when animation ends.
   */
  remove(event) {
    this.element.remove()
  }
}
