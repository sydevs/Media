import Keyframe from "editor/keyframe"
import Frames from "editor/frames"
import "jquery"

const Form = {
  oncreate: function(vnode) {
    $(vnode.dom.children[0]).accordion()
    $(".ui.checkbox").checkbox()
  },
  view: function() {
    const url = MEDITATION.audio
    const filename = url.substring(url.lastIndexOf('/')+1)

    return m(".editor-form", [
      m(".ui.styled.fluid.accordion", [
        m(".active.title", [m("i.dropdown.icon"), "1. Audio Track"]),
        m(".active.content", [
          m("p.hint", {}, [
            m("b", "Current file: "),
            filename,
          ]),
          m(".file.field", [
            m("input", { type: "file", name: "meditation[audio]", id: "meditation_audio" }),
          ]),
        ]),
        m(".title", [m("i.dropdown.icon"), "2. Choose Images or Videos"]),
        m(".content", [
          m(Frames, { frames: FRAMES }),
        ]),
        m(".title", [m("i.dropdown.icon"), "3. Review"]),
        m(".content", [
          m(".ui.doubling.centered.padded.four.column.grid",
            MEDITATION.keyframes.map((keyframe, index) => {
              keyframe.index = index
              keyframe.onremove = () => MEDITATION.keyframes.splice(index, 1)
              return m(Keyframe, keyframe)
            })
          )
        ]),
      ]),
      m(".ui.divider"),
      m(".field", [
        m(".ui.large.checkbox", [
          m("input", { type: "hidden", name: "meditation[published]", value: 0 }),
          m("input", { type: "checkbox", name: "meditation[published]", checked: MEDITATION.published, value: 1 }),
          m("label", "Mark as Complete"),
        ]),
      ]),
      m("button.ui.teal.button", "Save"),
      m("a.ui.button", { href: "/meditations" }, "Back"),
    ])
  }
}

export default Form
