import { Controller } from "stimulus"
import { Howl } from "howler"
import moment from "moment"
import momentDurationFormatSetup from "moment-duration-format"

momentDurationFormatSetup(moment)

/**
 * Controls playback of uploaded tracks
 */
export default class Player extends Controller {
  static targets = ["button", "elapsed", "like", "listens", "notch"]

  initialize() {
    this.updateElapsedTime = this.updateElapsedTime.bind(this)
  }

  /**
   * Create the sound with Howl
   */
  connect() {
    const href = this.buttonTarget.closest("form").getAttribute("action")
    const src = [href]

    this.sound = new Howl({ src })
    this.playing = false
    this.secondsElapsed = 0
    this.listens = parseInt(this.element.getAttribute("data-listens"))
    this.totalDuration = parseInt(this.element.getAttribute("data-duration"))
    this.liked = this.element.getAttribute("data-liked")
  }

  /**
   * Clean up existing Howl sounds from the environment when
   * disconnected from the DOM
   */
  disconnect() {
    this.sound.unload()
  }

  /**
   * Update the elapsed time on the player
   */
  updateElapsedTime() {
    this.secondsElapsed++

    let elapsedTime = moment.duration(this.secondsElapsed, "seconds")
                            .format("mm:ss")

    if (elapsedTime.length == 2) {
      elapsedTime = `00:${elapsedTime}`
    }

    this.elapsedTarget.innerText = elapsedTime
    this.notchTarget.style.left = `${this.secondsElapsed * 2}px`
  }

  get url() {
    return this.element.getAttribute("data-track")
  }

  /**
   * Toggle play/pause functionality on the sound
   */
  toggle(event) {
    event.preventDefault()

    if (this.playing) {
      this.pause()
    } else {
      this.play()
      this.listened()
    }
  }

  /**
   * Like or unlike the track
   */
  async like(event) {
    event.preventDefault()

    const url = `${this.url}/like.json`
    const method = this.liked ? "DELETE" : "POST"
    const response = await fetch(url, { method })

    if (response.status === 200) {
      const { likes } = await response.json()
      this.liked = method === "POST"

      this.likesTarget.innerText = `${likes} likes`
    }
  }


  /**
   * Pause the currently-playing track
   */
  pause() {
    this.buttonTarget.value = "Play"
    this.sound.pause()
    this.playing = false
    clearInterval(this.elapsedTimeInterval)
  }

  /**
   * Play the track defined by this player
   */
  play() {
    this.buttonTarget.value = "Pause"
    this.sound.play()
    this.playing = true
    this.elapsedTimeInterval = setInterval(this.updateElapsedTime, 1000)
  }

  /**
   * Track playback by a given client.
   */
  async listened() {
    const authenticityToken = this.element.querySelector(
      "input[name=\"authenticity_token\"]"
    ).value
    const method = "POST"
    const url = `${this.url}/listen.json`
    const headers = { "X-CSRF-Token": authenticityToken }
    const response = await fetch(url, { method, headers })

    if (response.status === 201) {
      const { listens } = await response.json()

      this.listensTarget.innerText = `${listens} listens`
    }
  }
}
