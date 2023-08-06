import "mithril"
import Editor from "editor/editor"

function load() {
  const root = document.getElementById('mithril')
  if (!root) return

  window.FRAMES = JSON.parse(root.dataset.frames)
  window.MEDITATION = JSON.parse(root.dataset.meditation)
  window.MEDITATION.playbackTime = 0
  m.mount(root, Editor)
}

$(document).on('turbo:load', load)
