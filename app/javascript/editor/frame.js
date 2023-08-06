
const Frame = {
  view: function(vnode) {
    let frame = vnode.attrs

    return m("a.frame.column", {
      href: "#",
      onclick: event => {
        frame.onselect()
        event.preventDefault()
        return false
      },
    }, [
      m("img.ui.circular.bordered.image", { src: frame.preview_url }),
      m(".center.aligned.field", [
        m("label", frame.title),
        m("p", frame.subtitle),
      ]),
    ])
  }
}

export default Frame
