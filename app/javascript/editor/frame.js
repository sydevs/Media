
const Frame = {
  view: function(vnode) {
    let frame = vnode.attrs
    let keyframe = typeof frame.seconds === "number"
    let time = keyframe ? new Date(frame.seconds * 1000).toISOString().slice(11, 19) : null

    return m("a.frame.column", {
      href: frame.onselect ? "#" : null,
      onclick: event => {
        frame.onselect()
        event.preventDefault()
        return false
      },
    }, [
      keyframe ?
        m("a.ui.small.right.corner.label", {
          onclick: event => {
            frame.onremove()
            event.preventDefault()
            return false
          },
        }, m("i.trash.icon"))
        : null,
      m(`${frame.video ? 'video' : 'img'}.ui.circular.bordered.image`, { src: frame.url }),
      m(".center.aligned.field", [
        m("label", frame.title),
        m("p", frame.subtitle),
        keyframe ? m(".ui.tiny.fluid.input", [
          m("input", { type: 'time', step: 1, value: time }),
        ]) : null,
      ]),
    ])
  }
}

export default Frame
