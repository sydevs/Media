import "mithril"
import Editor from "editor/editor"

function load() {
  const root = document.getElementById('mithril')
  m.mount(root, Editor)
}

load()
document.addEventListener('turbolinks:load', load)
