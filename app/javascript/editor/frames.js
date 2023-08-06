import Frame from "editor/frame"

let query = ""

const Frames = {
  view: function(vnode) {
    let frames = vnode.attrs.frames.filter(frame => {
      return frame.title.includes(query) || frame.subtitle.includes(query)
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
      m("p.hint", "Selecting an image will immediately add it to the meditation. If you make a mistake you can change or remove it in the \"Review\" section."),
      m(".ui.doubling.centered.padded.four.column.grid",
        frames.map((frame) => {
          frame.onselect = () => {
            const keyframe = { ...frame }
            keyframe.frame_id = keyframe.id
            keyframe.seconds = MEDITATION.playbackTime,
            delete keyframe.id
            delete keyframe.onselect
            MEDITATION.keyframes.push(keyframe)
            MEDITATION.keyframes = MEDITATION.keyframes.sort((a, b) => a.seconds - b.seconds)
            $.toast({
              class: "teal",
              message: `Added <b>${keyframe.title}</b> at ${new Date(keyframe.seconds * 1000).toISOString().slice(14, 19)}`
            })
          }
          return m(Frame, frame)
        })
      )
    ]
  }
}

export default Frames


