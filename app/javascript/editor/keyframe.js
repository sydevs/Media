
const Keyframe = {
  view: function(vnode) {
    let keyframe = vnode.attrs
    let time = new Date(keyframe.seconds * 1000).toISOString().slice(11, 19)

    return m(".frame.column", [
      m("a.ui.small.right.corner.label", {
        onclick: event => {
          keyframe.onremove()
          event.preventDefault()
          return false
        },
      }, m("i.trash.icon")),
      m(`${keyframe.video ? 'video' : 'img'}.ui.circular.bordered.image`, { src: keyframe.url }),
      m(".center.aligned.field", [
        m("label", keyframe.title),
        m("p", keyframe.subtitle),
        m(".ui.tiny.fluid.input", [
          m("input", {
            type: 'time', step: 1, value: time,
            onblur: event => {
              const [hours, minutes, seconds] = event.currentTarget.value.split(":")
              keyframe.seconds = 60 * 60 * hours + 60 * minutes + seconds
              editorMeditation.keyframes = editorMeditation.keyframes.sort((a, b) => a.seconds - b.seconds)
            }
          }),
        ]),
        m("input", { type: 'hidden', value: keyframe.id, name: `meditation[keyframes][${keyframe.index}][id]` }),
        m("input", { type: 'hidden', value: keyframe.frame_id, name: `meditation[keyframes][${keyframe.index}][frame_id]` }),
        m("input", { type: 'hidden', value: keyframe.seconds, name: `meditation[keyframes][${keyframe.index}][seconds]` }),
      ]),
    ])
  }
}

export default Keyframe
