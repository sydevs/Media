
let frameIndex = 0
let keyframes = []
let audio = null

function isCurrentFrame(index, time) {
  let currentFrame = keyframes[index]
  if (!currentFrame) return false

  if (currentFrame.seconds > time)
    return false

  let nextFrame = keyframes[index + 1]
  if (nextFrame && time >= nextFrame.seconds)
    return false

  return true
}

function updateFrame(time) {
  MEDITATION.playbackTime = time

  if (isCurrentFrame(frameIndex, time))
    return
    
  if (isCurrentFrame(frameIndex + 1, time)) {
    frameIndex += 1
  } else {
    frameIndex = 0
    for (let i = 0; i < keyframes.length; i++) {
      if (isCurrentFrame(i, time)) {
        frameIndex = i
        break
      }
    }
  }

  m.redraw()
}

const Preview = {
  oncreate: function(vnode) {
    audio = vnode.dom.querySelector("audio")
  },
  view: function() {
    keyframes = MEDITATION.keyframes.filter(kf => !kf._destroy)
    let currentFrame = keyframes[frameIndex]

    return [
      m(".editor-preview", [
        currentFrame ? m(`${currentFrame.video ? 'video' : 'img'}.ui.circular.bordered.image`, {
          src: currentFrame["url"],
          muted: true,
          autoplay: true,
        }) : null,
        m("audio", {
          src: MEDITATION.audio.url,
          controls: true,
          controlslist: "nofullscreen nodownload noremoteplayback noplaybackrate",
          ontimeupdate: event => { updateFrame(event.currentTarget.currentTime) }
        }),
        m(".ui.tiny.basic.icon.buttons", [
          m(".ui.button", {
            onclick: () => { audio ? audio.currentTime -= 5 : null }
          }, m("i.undo.alternate.icon")),
          m(".ui.button", {
            onclick: () => { audio ? audio.currentTime += 5 : null }
          }, m("i.redo.alternate.icon")),
        ])
      ])
    ]
  }
}

export default Preview
