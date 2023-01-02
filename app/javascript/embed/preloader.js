
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
    console.log('loadFrame', frame)
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
    console.log('wait for preloading')
    return Promise.all(this.#preloadPromises)
  }

  waitForFrameLoad(frame) {
    console.log('wait for frame load')
    if (frame.tagName == 'VIDEO') {
      return this.waitForMediaLoad(frame)
    } else {
      return this.waitForImageLoad(frame)
    }
  }

  waitForImageLoad(img) {
    console.log('wait for img load', img.src)

    if (img.complete) {
      console.log('already loaded image', img.src)
      return Promise.resolve()
    }
  
    return new Promise((resolve, reject) => {
      img.onload = () => {
        console.log('loaded img', img.src)
        resolve()
      }
      img.onerror = error => reject(error)
    })
  }

  waitForMediaLoad(media, desiredState = HTMLMediaElement.HAVE_ENOUGH_DATA) {
    console.log('wait for media load', media.src)

    if (media.readyState >= desiredState) {
      console.log('already loaded media', media.src)
      return Promise.resolve()
    }
  
    return new Promise((resolve, reject) => {
      media.oncanplay = () => {
        console.log('loaded media', media.src)
        resolve()
      }
      media.onerror = error => reject(error)
    })
  }
}

export default SahajMediaPreloader
