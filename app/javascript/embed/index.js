import SahajMediaPreloader from "embed/preloader"
import SahajMediaVisualizer from "embed/visualizer"

class SahajMediaEmbed {

  preloader = null
  visualizer = null

  #container
  #audio
  #frames
  #time
  #track
  #marker
  #begin

  get state() {
    return this.#container.dataset.state
  }

  set state(value) {
    this.#container.dataset.state = value
  }

  constructor() {
    console.log('load embedder')
    this.#container = document.getElementById('sym-container')
    this.#audio = document.getElementById('sym-audio')
    this.#frames = document.getElementById('sym-images').childNodes
    this.#time = document.getElementById('sym-time')
    this.#track = document.getElementById('sym-track')
    this.#marker = document.getElementById('sym-marker')

    console.log('start preloader')
    this.preloader = new SahajMediaPreloader(this.#frames, this.#audio, 5)
    this.preloader.waitForPreloading().then(() => {
      console.log('preloaded')
      this.#container.dataset.preloading = 'false'
    }).catch(error => {
      this.state = 'error'
      console.error(error)
    })

    this.visualizer = new SahajMediaVisualizer(window.sym.keyframes, this.#frames, this.#audio)

    this.#begin = document.getElementById('sym-begin')
    this.#begin.onclick = event => {
      this.state = 'playing'
      this.setPaused(false)
      setTimeout(() => this.#begin.remove(), 1000)
      event.stopPropagation()
      event.preventDefault()
      return false
    }

    this.#container.onclick = () => this.onClick()
    this.#container.ontouchend = () => this.onClick()
  }

  onClick() {
    if (this.state == 'intro') {
      return
    } else {
      this.setPaused(this.state == 'playing')
    }

    this.updateTime()
  }

  updateTime() {
    const time = this.#audio.currentTime
    const fraction = time / this.#audio.duration
    const degrees = fraction * 360
    const radians = (fraction * 2 - 0.5) * Math.PI
    const date = new Date(time * 1000)

    this.#time.innerText = `${date.getMinutes()}:${date.getSeconds().toString().padStart(2, '0')}`
    this.#track.style = `background-image: conic-gradient(#1E6C71 ${degrees}deg, transparent ${degrees}deg)`
    this.#marker.style.left = `calc(50% + ${50 * Math.cos(radians)}% - 4px)`
    this.#marker.style.top = `calc(50% + ${50 * Math.sin(radians)}% - 4px)`
    this.#marker.style.opacity = fraction > 0.995 ? 0 : 1
  }

  setPaused(paused = true) {
    if (paused) {
      this.#audio.pause()
      this.state = 'paused'
    } else {
      this.#audio.play()
      this.state = 'playing'
    }

    this.visualizer.setPaused(paused)
  }

}

if (document.readyState === "complete" || document.readyState === "interactive") {
  console.log('already loaded')
  window.SahajMedia = new SahajMediaEmbed()
} else {
  console.log('waiting for load')
  window.addEventListener("DOMContentLoaded", () => {
    window.SahajMedia = new SahajMediaEmbed()
  })
}

console.log('load embed.js')
