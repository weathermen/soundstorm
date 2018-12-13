import { Controller } from "stimulus"
import DialogTemplate from "../templates/dialog.html.haml"

/**
 * Modal Dialog Handlers
 */
export default class Dialog extends Controller {
  static targets = ["overlay", "window"]

  /**
   * Open the dialog with a remote link.
   */
  async open(event) {
    const [content, status, xhr] = event.detail

    if (status === 200) {
      const title = xhr.getResponseHeader("X-Page-Title")
      const dialog = DialogTemplate({ title, content })
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