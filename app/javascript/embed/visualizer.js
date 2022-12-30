
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

    audio.ontimeupdate = () => this.updateImage()
  }

  updateImage(img) {
    const time = this.#audio.currentTime
    const nextKeyframe = this.nextKeyframe

    if (time >= nextKeyframe.seconds) {
      const newFrame = this.#frames[nextKeyframe.frame_id]
      this.#activeFrame.classList.remove('active')
      newFrame.classList.add('active')
      this.#activeFrame = newFrame
      this.#currentId += 1
    }
  }
}

export default SahajMediaVisualizer
