
class SahajMediaPreloader {

  #preloadPromises = []
  #frameQueue = []

  constructor(images, media, preloadCount) {
    console.log('load preloader')
    this.#preloadPromises.push(this.waitForMediaLoad(media))

    for (let i = 0; i < images.length; i++) {
      if (i < preloadCount) {
        const promise = this.loadFrame(images[i])
        this.#preloadPromises.push(promise)
      } else if (i < preloadCount * 2) {
        this.loadFrame(images[i])
      } else {
        this.#frameQueue.push(images[i])
      }
    }
  }

  loadFrame(frame) {
    if (frame.dataset.src) {
      frame.src = frame.dataset.src
    }

    return this.waitForFrameLoad(frame).then(() => this.loadNextImage())
  }

  loadNextImage() {
    if (this.#frameQueue.length > 0) {
      this.loadFrame(this.#frameQueue.shift())
    }
  }

  waitForPreloading() {
    return Promise.all(this.#preloadPromises)
  }

  waitForFrameLoad(frame) {
    if (frame.tagName == 'VIDEO') {
      return this.waitForMediaLoad(frame)
    } else {
      return this.waitForImageLoad(frame)
    }
  }

  waitForImageLoad(img) {
    if (img.complete) {
      return Promise.resolve()
    }
  
    return new Promise((resolve, reject) => {
      img.onload = () => resolve()
      img.onerror = error => reject(error)
    })
  }

  waitForMediaLoad(media, desiredState = HTMLMediaElement.HAVE_ENOUGH_DATA) {
    if (media.readyState >= desiredState) {
      return Promise.resolve()
    }
  
    return new Promise((resolve, reject) => {
      media.oncanplay = () => resolve()
      media.onerror = error => reject(error)
    })
  }
}

export default SahajMediaPreloader
