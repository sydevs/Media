# README

## Ruby on Rails basics
 - [Ruby syntax refresher](https://learnxinyminutes.com/docs/ruby/)
 - The concept of Model-View-Controller is central to ruby. Here is an [MVC refresher](https://www.codecademy.com/article/mvc) on that if you need it. 
 - Ruby uses a package manager called Gem (this is comparable to NPM and Yarn) to manage dependent Ruby libraries.

## Setup the project on your system
 - [Install RVM](https://rvm.io/rvm/install) (Ruby Version Manager)
 - Run `rvm install 3.1.2` to install the Ruby version you'll need for this project.
 - Run `bundle install` in the root directory of this project, to install all ruby dependencies (aka gems).
 - Run `rails server` in the root of the project, to start the server. The site will then be accessible at `localhost:3000`

## Our configuration
I've set up this rails boilerplate with the same libraries and configuration we use on the other We Meditate projects. Hopefully that should make context switching generally easier.

That means:
 - The database is configured for PostgreSQL (though we won't need this for now)
 - CSS is written with [Sass](https://sass-lang.com/guide). Sass is the same project as SCSS, but it uses indentation instead of brackets.
 - HTML is written with [Slim](http://slim-lang.com/)
 - We're using vanilla JavaScript
 - There is a configuration for [Rubocop](https://rubocop.org/) and [ESLint](https://eslint.org/) in the root folder. If you install those two libraries in your IDE, then they should be able to automatically keep your code syntax consistent with our projects. Let me know if you want help with that.

## Files and folders
Here is a list of the key files and folders in a Rails project that you should know about.

Generally speaking, Rails is built using the idea of "convention over configuration." This means that things are always structured the same way in every rails project. All the css in a particular place, all the javascript in a particular place.

 - Web urls are defined in `config/routes.rb`
 - Each web url will map to a method in one of the controllers in `app/controllers`. That method will then prepare the any data which is needed to render the page.
 - Each controller method maps to one of the views in `app/views`. This is an automatic mapping, so for example `MeditationsController#embed` will by default render the html file at `app/views/meditations/embed.html.slim`
   - Generally, rails works in this way ( "convention over configuration"). This means that things usually just correspond automatically instead of needing to be defined explicitly.
 - JavaScript is defined in `app/javascript`. `application.js` is the entrypoint, you can create other files and then use import statements to use them in `application.js`
 - CSS is defined in `app/assets/stylesheets`. `application.css` is the entrypoint and will automatically include any other `css`, or `sass` files which are in the same folder (or a subfolder)
   - Javascript and CSS is automatically bundled and included on every page.

## What I have set up
To get you started, I've set up a few basics so that you can immediately start writing the HTML, CSS, JavaScript, and Rest API access without having to worry about other things so much.

 - I created a url which is `localhost:3000/embed/<meditation-id>`
 - You can edit the `embed` function in `app/controllers/meditations_controller.rb` to fetch the data you need for that page, then store it in a variable, so that it can be used in the HTML. I written some sample code in there to show you how.
 - I added the `app/views/meditations/embed.html.slim` file where you can write HTML. Again there is some sample code in there.
 - CSS can be added in `app/assets/stylesheets/embed`
 - JavaScript can be added in `app/javascript/application.js`
 - I also a library to make HTTP request easier ([httparty](https://github.com/jnunemaker/httparty)), and I created an example file to wrap up all bubble requests `app/controllers/concerns/bubble_api.rb`. Again there is some sample code in there to show how HTTParty can be used.
   - Alternatively, I previously set up a system which syncs the Bubble data to a service called Airtable. So you could also get the data from Airtable instead of Bubble's REST API, if you like. Let me know if you want to do that.

## Other tips
 - You can run `rails console` in the project's root folder to load up the server but with a command line. From this command line you can call arbirary Ruby code, or call methods from the codebase to test them out.
 - To print something to the console, use something like one of these:
   - `puts @variable.inspect`
   - `puts "NOTICE ME: #{@variable.inspect}"`
 - You can add environmental variables to the `.env` file. These will then get automatically loaded, but you need to restart the server to load and changes.
   - If it's a sensitive variable, then create a `.env.local` file, which will do the same thing but be ignored by version controll.