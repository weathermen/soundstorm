import { Controller } from "stimulus"
import DialogTemplate from "../templates/dialog.html.haml"
import { template } from "lodash"
import hotkeys from "hotkeys-js"

/**
 * Modal Dialog Handlers
 */
export default class Dialog extends Controller {
  static targets = ["overlay", "window"]

  get template() {
    return template(DialogTemplate)
  }

  initialize() {
    this.close = this.close.bind(this)
  }

  connect() {
    hotkeys("esc", this.close)
  }

  /**
   * Open the dialog with a remote link.
   */
  open(event) {
    const dom = event.detail[0]
    const xhr = event.detail[2]
    const content = dom.body.innerHTML
    const title = xhr.getResponseHeader("X-Page-Title")
    const html = this.template({ title, content })
    const body = document.querySelector("body")
    const div = document.createElement("div")
    div.innerHTML = html
    const dialog = div.firstElementChild

    body.appendChild(dialog)
  }

  /**
   * Close the dialog by clicking the "X" in the corner.
   */
  close(event) {
    event.preventDefault()

    this.element.remove()
  }
}
