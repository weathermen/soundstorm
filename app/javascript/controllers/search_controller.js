import { Controller } from "stimulus"
import Turbolinks from "turbolinks"

export default class SearchController extends Controller {
  get action() {
    return this.element.getAttribute("action")
  }

  get query() {
    const entries = [...new FormData(this.element).entries()]

    return entries.map(entry => entry.map(encodeURIComponent).join("="))
                  .join("&")
  }

  get url() {
    return `${this.action}?${this.query}`
  }

  results(event) {
    Turbolinks.visit(this.url)
  }
}
