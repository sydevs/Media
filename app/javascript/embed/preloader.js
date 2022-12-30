
class SahajMediaPreloader {

  #preloadPromises = []
  #imageQueue = []

  constructor(images, audio, preloadCount) {
    console.log('load preloader')
    this.#preloadPromises.push(this.waitForAudioLoad(audio))

    for (let i = 0; i < images.length; i++) {
      if (i < preloadCount) {
        const promise = this.loadImage(images[i])
        this.#preloadPromises.push(promise)
      } else if (i < preloadCount * 2) {
        this.loadImage(images[i])
      } else {
        this.#imageQueue.push(images[i])
      }
    }
  }

  loadImage(img) {
    if (img.dataset.src) {
      img.src = img.dataset.src
    }

    console.log('load img', img.src)
    return this.waitForImageLoad(img).then(() => this.loadNextImage())
  }

  loadNextImage() {
    if (this.#imageQueue.length > 0) {
      this.loadImage(this.#imageQueue.shift())
    }
  }

  waitForPreloading() {
    return Promise.all(this.#preloadPromises)
  }

  waitForImageLoad(img) {
    if (img.complete) {
      return Promise.resolve()
    }
  
    return new Promise((resolve, reject) => {
      img.onload = () => {
        console.log('loaded', img.src)
        resolve()
      }
      img.onerror = error => reject(error)
    })
  }

  waitForAudioLoad(audio) {
    if (audio.readyState == HTMLMediaElement.HAVE_ENOUGH_DATA) {
      return Promise.resolve()
    }
  
    return new Promise((resolve, reject) => {
      audio.oncanplay = () => resolve()
      audio.onerror = error => reject(error)
    })
  }
}

export default SahajMediaPreloader
