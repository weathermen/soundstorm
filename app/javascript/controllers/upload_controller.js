import { Controller } from "stimulus"

export default class Upload extends Controller {
  static targets = ["progress", "item", "fieldset"]

  start(event) {
    this.progressTarget.classList.remove("form__hint--hidden")
  }

  progress(event) {
    const { detail: { progress } } = event
    const percent = Math.ceil(progress)

    this.progressTarget.innerText = `Uploading... ${percent}% complete`
  }

  /**
   * Add a new nested item to the form with an ID that is greater than
   * the ID that came before it. This is to appease Rails' nested form
   * system.
   */
  add(event) {
    event.preventDefault()

    const targets = this.itemTargets
    const item =  targets.pop()
    const newItem = item.cloneNode(true)
    const inputs = newItem.querySelectorAll("input, textarea")
    const id = new Date().getTime()

    inputs.forEach(function(input) {
      const name = input.getAttribute("name")
                        .replace("released_tracks[0]", `released_tracks[${id}]`)

      input.setAttribute("name", name)
    })

    const num = newItem.querySelector("input[type=number]")
    num.value++

    if (newItem.classList.contains("released-track--removed")) {
      newItem.classList.remove("released-track--removed")
    }

    this.fieldsetTarget.appendChild(newItem)
  }

  remove(event) {
    event.preventDefault()

    const track = event.currentTarget.closest(".released-track")
    const field = track.querySelector("[data-destroy-field]")
    const inputs = track.querySelectorAll("input, textarea")

    field.value = "1"

    inputs.forEach(function(input) {
      input.setAttribute("disabled", "disabled")
    })

    track.classList.add("released-track--removed")
  }
}
