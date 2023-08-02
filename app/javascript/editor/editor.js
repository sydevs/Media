import Preview from "editor/preview"
import Form from "editor/form"

const Editor = {
	view: function() {
		return m(".ui.grid", [
			m(".five.wide.column", m(Preview)),
			m(".eleven.wide.column", m(Form)),
		])
	}
}

export default Editor
