
class SahajMediaEmbed {

  #container
  #audio
  #images
  #time
  #track
  #marker
  #activeImage

  constructor() {
    this.#container = document.getElementById('sym-container')
    this.#audio = document.getElementById('sym-audio')
    this.#images = document.getElementById('sym-images').childNodes
    this.#time = document.getElementById('sym-time')
    this.#track = document.getElementById('sym-track')
    this.#marker = document.getElementById('sym-marker')
    this.#activeImage = this.#images[0]

    this.#audio.ontimeupdate = () => {
      this.updateTime()
      this.updateImage()
    }

    document.getElementById('sym-begin').onclick = (event) => {
      this.#container.dataset.state = 'playing'
      this.#audio.play()
      event.preventDefault()
      return false
    }
  }

  updateTime() {
    const time = this.#audio.currentTime
    const fraction = time / this.#audio.duration
    const degrees = fraction * 360
    const radians = (fraction * 2 - 0.5) * Math.PI

    this.#time.innerText = new Date(time * 1000).toISOString().substring(14, 19)
    this.#track.style = `background-image: conic-gradient(#1E6C71 ${degrees}deg, transparent ${degrees}deg)`
    this.#marker.style.left = `calc(50% + ${50 * Math.cos(radians)}% - 4px)`
    this.#marker.style.top = `calc(50% + ${50 * Math.sin(radians)}% - 4px)`
    this.#marker.style.opacity = fraction > 0.995 ? 0 : 1
  }

  updateImage() {
    const time = this.#audio.currentTime
    let newImage = null

    /*for (let i in this.#images) {
      if (!newImage || Number(this.#images[i].dataset.seconds) < time) {
        newImage = this.#images[i]
      } else {
        break
      }
    }*/

    let nextImage = this.#activeImage.nextSibling
    console.log('check', time, '>=', Number(nextImage.dataset.seconds), time >= Number(nextImage.dataset.seconds))
    if (time >= Number(nextImage.dataset.seconds)) {
      newImage = nextImage
    }

    if (newImage && this.#activeImage != newImage) {
      this.#activeImage.classList.remove('active')
      newImage.classList.add('active')
      this.#activeImage = newImage
    }
  }

}

document.addEventListener('DOMContentLoaded', function() {
  window.SahajMedia = new SahajMediaEmbed()
})

console.log('load embed.js')