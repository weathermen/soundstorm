import { Controller } from "stimulus"

export default class ReleaseController extends Controller {
  static targets = ["player"]

  cue(event) {
    const content = event.detail[0]

    this.playerTarget.replaceChild(content)
    this.playerTarget.querySelector("video").play()
  }
}
