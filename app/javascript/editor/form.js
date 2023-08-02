import Keyframe from "./keyframe"
import Frames from "./frames"
import "jquery"

const Form = {
  oncreate: function(vnode) {
    $(vnode.dom.children[0]).accordion()
  },
  view: function() {
    return m(".editor-form", [
      m(".ui.styled.fluid.accordion", [
        m(".active.title", [m("i.dropdown.icon"), "1. Audio Track"]),
        m(".active.content", [
          m("input.ui.invisible.file.input", { type: "file" }),
          m(".ui.placeholder.segment", [
            m(".ui.icon.header", [
              m("i.upload.icon"),
              "Click here to upload",
            ])
          ]),
        ]),
        m(".title", [m("i.dropdown.icon"), "2. Choose Images or Videos"]),
        m(".content", [
          m(Frames, { frames: editorFrames }),
        ]),
        m(".title", [m("i.dropdown.icon"), "3. Review"]),
        m(".content", [
          m(".ui.doubling.centered.padded.four.column.grid",
            editorMeditation.keyframes.map((keyframe, index) => {
              keyframe.index = index
              keyframe.onremove = () => editorMeditation.keyframes.splice(index, 1)
              return m(Keyframe, keyframe)
            })
          )
        ]),
      ]),
      m(".ui.divider"),
      m("button.ui.orange.button", [
        m("i.checkmark.icon"),
        "Mark as Complete",
      ]),
      m("button.ui.teal.button", "Save"),
      m("a.ui.button", { href: "/meditations" }, "Back"),
    ])
  }
}

export default Form
