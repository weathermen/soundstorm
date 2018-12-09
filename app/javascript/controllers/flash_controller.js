import { Controller } from "stimulus"
import { isEmpty } from "lodash"
import FlashMessage from "../templates/flash_message.html.haml"

/**
 * Render flash messages from the `X-Flash-Messages` header on Ajax
 * requests.
 */
export default class Flash extends Controller {
  initialize() {
    this.parse = this.parse.bind(this)
  }

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
  parse(event) {
    const xhr = event.detail[0]
    const flash = JSON.parse(
      xhr.getResponseHeader("X-Flash-Messages")
    )

    if (!isEmpty(flash)) {
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
