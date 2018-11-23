import { Controller } from "stimulus"
import { Howl } from "howler"

/**
 * Controls playback of uploaded tracks
 */
export default class Player extends Controller {
  static targets = ["button", "elapsed"]

  /**
   * Create the sound with Howl
   */
  connect() {
    const href = this.buttonTarget.current.getAttribute("href")
    const src = [href]

    this.sound = new Howl({ src })
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
    this.elapsedTarget.current.innerText = this.sound.duration()
  }

  /**
   * Test if a track is currently playing
   */
  get playing() {
    return typeof this.elapsedTimeInterval !== "undefined"
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
    this.buttonTarget.current.innerText = "Play"
    this.sound.pause()
    clearInterval(this.elapsedTimeInterval)
  }

  /**
   * Play the track defined by this player
   */
  play() {
    this.buttonTarget.current.innerText = "Pause"
    this.sound.play()
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
}
