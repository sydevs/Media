
class SahajMediaEmbed {

  #container
  #audio
  #images
  #time
  #track
  #marker
  #begin
  #activeImage

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
    this.#activeImage = this.#images[0]

    this.#audio.ontimeupdate = () => {
      //this.updateTime()
      this.updateImage()
    }

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

    this.waitForPreloading()
  }

  waitForPreloading() {
    const loading = Array.from(this.#images).slice(0, 3).map(waitForImageLoad)
    loading.push(waitForMediaLoad(this.#audio))
    Promise.all(loading).then(() => {
      this.#container.dataset.preloading = 'false'
    }).catch(error => {
      console.log(error)
    })
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

function waitForImageLoad(img) {
  if (img.complete) {
    return Promise.resolve()
  }

  return new Promise((resolve, reject) => {
    img.onload = () => resolve()
    img.onerror = error => reject(error)
  });
}

function waitForMediaLoad(media) {
  if (media.readyState == HTMLMediaElement.HAVE_ENOUGH_DATA) {
    return Promise.resolve()
  }

  return new Promise((resolve, reject) => {
    media.oncanplay = () => resolve()
    media.onerror = error => reject(error)
  })
}

document.addEventListener('DOMContentLoaded', function() {
  window.SahajMedia = new SahajMediaEmbed()
})

console.log('load embed.js')