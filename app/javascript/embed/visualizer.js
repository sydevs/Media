
class SahajMediaVisualizer {

  #audio
  #currentId = 0
  #activeFrame
  #keyframes
  #frames

  get currentKeyframe() {
    return this.#keyframes[this.#currentId]
  }

  get nextKeyframe() {
    return this.#keyframes[this.#currentId + 1]
  }

  constructor(keyframes, frames, audio) {
    console.log('load visualizer')
    this.#audio = audio
    this.#keyframes = keyframes
    this.#activeFrame = frames[0]

    this.#frames = {}
    frames.forEach(frame => {
      this.#frames[frame.dataset.id] = frame
    })

    audio.ontimeupdate = () => this.updateFrame()
  }

  setPaused(paused = true) {
    if (this.#activeFrame.tagName != 'VIDEO')
      return

    if (paused)
      this.#activeFrame.pause()
    else
      this.#activeFrame.play()
  }

  updateFrame() {
    const time = this.#audio.currentTime
    const nextKeyframe = this.nextKeyframe

    if (time >= nextKeyframe.seconds) {
      this.showFrame(this.#frames[nextKeyframe.frame_id])
      this.#currentId += 1
    }
  }

  showFrame(frame) {
    if (frame.tagName == 'VIDEO') {
      frame.currentTime = 0
      frame.play()
    }

    this.#activeFrame.classList.remove('active')
    frame.classList.add('active')
    this.#activeFrame = frame
  }
}

export default SahajMediaVisualizer
