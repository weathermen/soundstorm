import { Controller } from "stimulus"
// import { Howl } from "howler"
import HLS from "hls.js"
import moment from "moment"
import momentDurationFormatSetup from "moment-duration-format"
import { each } from "lodash"

momentDurationFormatSetup(moment)

/**
 * Controls playback of uploaded tracks
 */
export default class Player extends Controller {
  static targets = ["button", "elapsed", "like", "listens", "notch", "waveform", "video"]

  initialize() {
    this.updateElapsedTime = this.updateElapsedTime.bind(this)
    this.updateProgress = this.updateProgress.bind(this)
  }

  /**
   * Create the sound with Howl
   */
  connect() {
    this.playing = false
    this.streamURL = this.buttonTarget.getAttribute("href")

    if (HLS.isSupported()) {
      this.sound = new HLS()
      this.sound.loadSource(this.streamURL)
      this.sound.attachMedia(this.videoTarget)
    } else if (this.videoTarget.canPlayType("application/vnd.apple.mpegurl")) {
      this.sound = this.videoTarget
      this.sound.src = this.streamURL
    }

    this.videoTarget.addEventListener("play", this.start)
    this.videoTarget.addEventListener("pause", this.stop)
  }

  /**
   * Update the elapsed time on the player every second it is playing
   */
  updateElapsedTime() {
    const secondsElapsed = this.videoTarget.currentTime

    let elapsedTime = moment.duration(secondsElapsed, "seconds")
                            .format("mm:ss")

    if (elapsedTime.length == 2) {
      elapsedTime = `00:${elapsedTime}`
    }

    this.elapsedTarget.innerText = elapsedTime

  }

  updateProgress() {
    const totalDuration = this.data.get("duration")
    const secondsElapsed = this.videoTarget.currentTime
    const percent = (secondsElapsed / totalDuration) * 100

    this.notchTarget.style.left = `${percent}%`
  }

  /**
   * Get position of an element in the DOM.
   */
  getPosition(el) {
    var xPos = 0
    var yPos = 0

    while (el) {
      if (el.tagName == "BODY") {
        // deal with browser quirks with body/window/document and page scroll
        var xScroll = el.scrollLeft || document.documentElement.scrollLeft
        var yScroll = el.scrollTop || document.documentElement.scrollTop

        xPos += (el.offsetLeft - xScroll + el.clientLeft)
        yPos += (el.offsetTop - yScroll + el.clientTop)
      } else {
        // for all other non-BODY elements
        xPos += (el.offsetLeft - el.scrollLeft + el.clientLeft)
        yPos += (el.offsetTop - el.scrollTop + el.clientTop)
      }

      el = el.offsetParent
    }
    return {
      x: xPos,
      y: yPos
    }
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
    const method = this.data.get("liked") ? "DELETE" : "POST"
    const response = await fetch(url, { method })

    if (response.status === 200) {
      const { likes } = await response.json()
      this.data.set("liked", method === "POST")

      this.likesTarget.innerText = `${likes} likes`
    }
  }

  /**
   * Seek to the position of the track that was clicked on the waveform.
   */
  seek(event) {
    const parentPosition = this.getPosition(event.currentTarget)
    const xPosition = event.clientX - parentPosition.x
    const percent = (xPosition / event.currentTarget.clientWidth) * 100
    const totalDuration = this.data.get("duration")
    const trackPosition = Math.ceil((percent / 100) * totalDuration)

    this.data.set("seek-position", trackPosition)

    this.videoTarget.currentTime = trackPosition
    this.notchTarget.style.left = `${percent}%`
    this.updateElapsedTime()
  }

  /**
   * Pause the currently-playing track
   */
  pause() {
    this.videoTarget.pause()
    this.stop()
    this.playing = false

    this.buttonTarget.classList.remove("player__icon--playing")
    this.buttonTarget.classList.add("player__icon--paused")
  }

  stopAllOtherSounds() {
    const player = document.querySelector(".player__icon--playing")

    if (player) {
      player.dispatchEvent(new Event("click"))
    }
  }

  /**
   * Play the track defined by this player
   */
  play() {
    this.stopAllOtherSounds()
    this.videoTarget.play()
    this.playing = true

    this.buttonTarget.classList.remove("player__icon--paused")
    this.buttonTarget.classList.add("player__icon--playing")
  }

  start() {
    this.elapsedTimeInterval = setInterval(this.updateElapsedTime, 1000)
    this.progressInterval = setInterval(this.updateProgress, 1)
  }

  stop() {
    clearInterval(this.elapsedTimeInterval)
    clearInterval(this.progressInterval)
  }

  /**
   * Track playback by a given client.
   */
  async listened() {
    const csrfToken = document.querySelector("meta[name=\"csrf-token\"]")
                              .getAttribute("content")
    const method = "POST"
    const url = `${this.url}/listen.json`
    const headers = { "X-CSRF-Token": csrfToken }
    const response = await fetch(url, { method, headers })

    if (response.status === 201) {
      const { listens } = await response.json()

      this.listensTarget.innerText = `${listens} listens`
    }
  }
}
