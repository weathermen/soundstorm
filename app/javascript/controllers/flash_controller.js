import { Controller } from "stimulus"
import Template from "../templates/flash_message.html.haml"

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

    console.log(flash)

    flash.forEach(this.render)
  }

  /**
   * Render flash message data to the UI by appending it to the current
   * element.
   */
  render(type, message) {
    this.element.append(
      Template({ type, message })
    )
  }
}
