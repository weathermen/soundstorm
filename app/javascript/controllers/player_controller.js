import { Controller } from "stimulus"
import { Howl } from "howler"
import moment from "moment"
import momentDurationFormatSetup from "moment-duration-format"

momentDurationFormatSetup(moment)

/**
 * Controls playback of uploaded tracks
 */
export default class Player extends Controller {
  static targets = ["button", "elapsed", "like"]

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
    this.track()
  }

  /**
   * Track playback by a given client.
   */
  track() {
    const method = "POST"
    const url = `${this.url}/listen`

    fetch(url, { method })
  }

  like() {
  }
}
