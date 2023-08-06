
let frameIndex = 0

function isCurrentFrame(index, time) {
  let currentFrame = MEDITATION.keyframes[index]
  if (!currentFrame) return false

  let nextFrame = MEDITATION.keyframes[index + 1]
  if (!nextFrame) return true

  if (currentFrame.seconds <= time && time < nextFrame.seconds)
    return true

  return false
}

function updateFrame(time) {
  MEDITATION.playbackTime = time

  if (isCurrentFrame(frameIndex, time)) {
    // Do nothing
  } else if (isCurrentFrame(frameIndex + 1, time)) {
    frameIndex += 1
    m.redraw()
  } else {
    frameIndex = 0
    for (let i = 0; i < MEDITATION.keyframes.length; i++) {
      if (isCurrentFrame(i, time)) {
        frameIndex = i
        break
      }
    }

    m.redraw()
  }
}

const Preview = {
  view: function() {
    let currentFrame = MEDITATION.keyframes[frameIndex]

    return [
      m(".editor-preview", [
        m(`${currentFrame.video ? 'video' : 'img'}.ui.circular.image`, {
          src: currentFrame["url"],
          muted: true,
          autoplay: true,
        }),
        m("audio", {
          src: MEDITATION.audio,
          controls: true,
          controlslist: "nofullscreen nodownload noremoteplayback noplaybackrate",
          ontimeupdate: event => { updateFrame(event.currentTarget.currentTime) }
        })
      ])
    ]
  }
}

export default Preview
