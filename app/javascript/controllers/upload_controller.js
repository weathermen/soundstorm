import { Controller } from "stimulus"

export default class Upload extends Controller {
  static targets = ["progress"]

  start(event) {
    this.progressTarget.classList.remove("form__hint--hidden")
  }

  progress(event) {
    const { detail: { progress } } = event
    const percent = Math.ceil(progress)

    this.progressTarget.innerText = `Uploading... ${percent}% complete`
  }
}
