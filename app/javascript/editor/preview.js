
let frameIndex = 0
editorMeditation.playbackTime = 0

function isCurrentFrame(index, time) {
  let currentFrame = editorMeditation.keyframes[index]
  if (!currentFrame) return false

  let nextFrame = editorMeditation.keyframes[index + 1]
  if (!nextFrame) return true

  if (currentFrame.seconds <= time && time < nextFrame.seconds)
    return true

  return false
}

function updateFrame(time) {
  editorMeditation.playbackTime = time

  if (isCurrentFrame(frameIndex, time)) {
    // Do nothing
  } else if (isCurrentFrame(frameIndex + 1, time)) {
    frameIndex += 1
    m.redraw()
  } else {
    for (let i = 0; i < editorMeditation.keyframes.length; i++) {
      if (isCurrentFrame(i, time)) {
        frameIndex = i
        m.redraw()
        return
      }
    }
  }
}

const Preview = {
  view: function() {
    let currentFrame = editorMeditation.keyframes[frameIndex]

    return [
      m(".editor-preview", [
        m(`${currentFrame.video ? 'video' : 'img'}.ui.circular.image`, {
          src: currentFrame["url"],
          muted: true,
          autoplay: true,
        }),
        m("audio", {
          src: editorMeditation.audio,
          controls: true,
          controlslist: "nofullscreen nodownload noremoteplayback noplaybackrate",
          ontimeupdate: event => { updateFrame(event.currentTarget.currentTime) }
        })
      ])
    ]
  }
}

export default Preview
