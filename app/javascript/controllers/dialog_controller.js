import { Controller } from "stimulus"
import { template } from "lodash"

const DialogTemplate = ""

/**
 * Modal Dialog Handlers
 */
export default class Dialog extends Controller {
  static targets = ["overlay", "window"]

  get template() {
    return template(DialogTemplate)
  }

  /**
   * Open the dialog with a remote link.
   */
  async open(event) {
    const [content, status, xhr] = event.detail

    if (status === 200) {
      const title = xhr.getResponseHeader("X-Page-Title")
      const dialog = this.template({ title, content })
      const body = document.querySelector("body")

      body.appendChild(dialog)
    }
  }

  /**
   * Close the dialog by clicking the "X" in the corner.
   */
  close(event) {
    event.preventDefault()

    this.element.remove()
  }
}
