// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "jquery"
import "fomantic-ui"
import "editor"

if (typeof window !== 'undefined' && window.top === window.self) { 
  window.location.assign('https://app.storyblok.com/oauth/app_redirect')
}
