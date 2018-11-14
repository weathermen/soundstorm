import { Controller } from 'stimulus'
import { Howl } from 'howler'

// Controls playback of uploaded tracks
export default class extends Controller {
  static targets = ['button']

  // Instantiate a new Howl instance
  connect() {
    const href = this.buttonTarget.current.getAttribute('href')
    const src = [href]

    this.sound = new Howl({ src })
  }

  // Clean up existing Howl sounds from the environment when
  // disconnected from the DOM
  disconnect() {
    this.sound.unload()
  }

  updateElapsedTime() {
    this.elapsedTarget.current.innerText = this.sound.duration()
  }

  // Toggle play/pause functionality on the sound
  toggle(event) {
    if (this.sound.playing) {
      this.buttonTarget.current.innerText = 'Play'
      this.sound.pause()
      clearInterval(this.elapsedTimeInterval)
    } else {
      this.buttonTarget.current.innerText = 'Pause'
      this.sound.play()
      this.elapsedTimeInterval = setInterval(this.updateElapsedTime, 1000);
    }
  }
}
