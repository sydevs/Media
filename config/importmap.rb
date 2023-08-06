# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

#pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/embed", under: "embed"
pin_all_from "app/javascript/editor", under: "editor"

pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.6.3/dist/jquery.min.js", preload: true
pin "mithril", to: "https://unpkg.com/mithril/mithril.js", preload: false
pin "fomantic-ui", to: "https://ga.jspm.io/npm:fomantic-ui@2.9.2/dist/semantic.js"
