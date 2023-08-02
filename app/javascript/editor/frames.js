import Frame from "./frame"

let query = ""

const Frames = {
  view: function(vnode) {
    let frames = vnode.attrs.frames.filter(frame => {
      return frame.title.includes(query)
    })

    frames.length = Math.min(frames.length, 4)

    return [
      m(".field", [
        m(".ui.fluid.icon.input.focus", [
          m("i.search.icon"),
          m("input", {
            type: "text",
            placeholder: "Search...",
            onkeyup: event => { query = event.currentTarget.value }
          }),
        ]),
      ]),
      m("p.hint", "Selecting an image will immediately add it to the meditation. If you make a mistake you can modify it in the \"Review\" section."),
      m(".ui.doubling.centered.padded.four.column.grid",
        frames.map((frame) => {
          frame.onselect = () => {
            const keyframe = { ...frame }
            keyframe.frame_id = keyframe.id
            keyframe.seconds = editorMeditation.playbackTime,
            delete keyframe.id
            delete keyframe.onselect
            editorMeditation.keyframes.push(keyframe)
            editorMeditation.keyframes = editorMeditation.keyframes.sort((a, b) => a.seconds - b.seconds)
          }
          return m(Frame, frame)
        })
      )
    ]
  }
}

export default Frames


