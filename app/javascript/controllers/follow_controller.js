import { Controller } from "stimulus"

export default class Follow extends Controller {
  static targets = ["button"]

  toggle(event) {
    const button = this.button.current

    if (button.innerText === "Unfollow") {
      button.innerText = "Follow"
    } else {
      button.innerText = "Unfollow"
    }

    button.classList.toggleClass("profile__follow-button--clicked")
  }
}
