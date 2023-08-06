
const Frame = {
  view: function(vnode) {
    let frame = vnode.attrs

    return m("a.frame.center.aligned.column", {
      href: "#",
      onclick: event => {
        frame.onselect()
        event.preventDefault()
        return false
      },
    }, [
      m("img.ui.circular.bordered.centered.image", { src: frame.thumbnail_url }),
      m(".field", [
        m("label", [
          m(`i.${frame.video ? 'video' : 'image'}.inline.icon`),
          [frame.title, frame.subtitle].filter(t => t).join(" - "),
        ]),
      ]),
    ])
  }
}

export default Frame
