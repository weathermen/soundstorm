import { Controller } from "stimulus"
import FlashMessage from "../templates/flash_message.html.haml"

/**
 * Render flash messages from the `X-Flash-Messages` header on Ajax
 * requests.
 */
export default class Flash extends Controller {
  /**
   * Bind event that parses flash headers into data
   */
  connect() {
    document.addEventListener("ajax:complete", this.parse)
  }

  disconnect() {
    document.removeEventListener("ajax:complete", this.parse)
  }

  /**
   * Parse flash messages header and render each message
   */
  parse(xhr) {
    const flash = JSON.parse(
      xhr.getResponseHeader("X-Flash-Messages")
    )

    if (flash) {
      flash.forEach(this.render)
    }
  }

  /**
   * Render flash message data to the UI by appending it to the current
   * element.
   */
  render(type, message) {
    this.element.append(
      FlashMessage({ type, message })
    )
  }
}
