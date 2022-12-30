import SahajMediaPreloader from "embed/preloader"
import SahajMediaVisualizer from "embed/visualizer"

class SahajMediaEmbed {

  preloader = null
  visualizer = null

  #container
  #audio
  #images
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
    this.#container = document.getElementById('sym-container')
    this.#audio = document.getElementById('sym-audio')
    this.#images = document.getElementById('sym-images').childNodes
    this.#time = document.getElementById('sym-time')
    this.#track = document.getElementById('sym-track')
    this.#marker = document.getElementById('sym-marker')

    this.preloader = new SahajMediaPreloader(this.#images, this.#audio, 5)
    this.preloader.waitForPreloading().then(() => {
      this.#container.dataset.preloading = 'false'
    }).catch(error => {
      console.log(error)
    })

    this.visualizer = new SahajMediaVisualizer(window.sym.keyframes, this.#images, this.#audio)

    this.#begin = document.getElementById('sym-begin')
    this.#begin.onclick = event => {
      this.state = 'playing'
      this.#audio.play()
      setTimeout(() => this.#begin.remove(), 1000)
      event.stopPropagation()
      event.preventDefault()
      return false
    }

    this.#container.onclick = event => {
      if (this.state == 'intro') {
        return
      } else if (this.state == 'paused') {
        this.#audio.play()
        this.state = 'playing'
      } else {
        this.#audio.pause()
        this.state = 'paused'
      }

      this.updateTime()
      event.stopPropagation()
      event.preventDefault()
      return false
    }
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

}

document.addEventListener('DOMContentLoaded', function() {
  window.SahajMedia = new SahajMediaEmbed()
})

console.log('load embed.js')