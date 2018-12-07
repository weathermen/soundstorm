import { Controller } from "stimulus"

/**
 * Behavior for individual flash messages, like closing and timeouts.
 */
export default class FlashMessage extends Controller {
  get type() {
    return this.data.get("type")
  }

  connect() {
    if (this.type === "notice") {
      setTimeout(this.close, 15000)
    }
  }

  /**
   * Remove this flash message from the DOM
   */
  close(event) {
    event.preventDefault()

    this.element.remove()
  }
}
