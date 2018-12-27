import { Controller } from "stimulus"

export default class Nested extends Controller {
  static targets = ["list", "item"]
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
    const num = newItem.querySelector("input[type=number]")

    inputs.forEach(function(input) {
      const name = input.getAttribute("name")
                        .replace("released_tracks[0]", `released_tracks[${id}]`)

      input.setAttribute("name", name)
    })


    if (newItem.classList.contains("released-track--removed")) {
      newItem.classList.remove("released-track--removed")
    } else {
      num.value++
    }

    this.listTarget.appendChild(newItem)
  }

  remove(event) {
    event.preventDefault()

    const track = event.currentTarget.closest("[data-target=\"nested.item\"]")
    const field = track.querySelector("[data-destroy-field]")
    const inputs = track.querySelectorAll("input, textarea")

    field.value = "1"

    inputs.forEach(function(input) {
      input.setAttribute("disabled", "disabled")
    })

    track.classList.add("released-track--removed")
  }
}
