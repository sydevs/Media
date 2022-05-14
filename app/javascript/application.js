// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

let audio, video, image, frames;

function updateImage(curTime) {
    console.log(curTime);




    
}

document.addEventListener("DOMContentLoaded", () => { 
    debugger;

    video = document.getElementById('med_video');
    audio = document.getElementById('med_audio');
    image = document.getElementById('med_img');

    audio.addEventListener("seeking", () => { 
        updateImage(audio.currentTime)
     });

 });



