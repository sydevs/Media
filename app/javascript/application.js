// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

let audio, video, image, frames;

function updateImage(curTime) {
    console.log(curTime);    
    for (let i=0; i<frames.length;i++ ){
        if(i == (frames.length-1)){
            if( curTime >= frames[i][1]  ){
                image.src = frames[i][0];
                console.log(frames[i][0])
            } 
        }else{
            if( curTime > frames[i][1] && curTime < frames[i+1][1]  ){
                // console.log('here');
                image.src = frames[i][0];
                console.log(frames[i][0])
            } 

        }
    }
}

document.addEventListener("DOMContentLoaded", () => { 
    // data is a global variable set from embed.html.slim
    frames = JSON.parse(data.replace(/&quot;/g, '"'))
    
    video = document.getElementById('med_video');
    audio = document.getElementById('med_audio');
    image = document.getElementById('med_img');
    image.src ="http://www.meditatenepal.org/img/white.jpg";

    // image.src = frames[0][0];

    // audio.addEventListener("seeking", () => { 
    //     updateImage(audio.currentTime)
    //  });


    //  audio.addEventListener("play", () => { 
    //     updateImage(audio.currentTime)
    //  });

    //  audio.addEventListener("playing", () => { 
    //      
    //     updateImage(audio.currentTime)
    //  });


     audio.addEventListener('timeupdate', (event) => {
        updateImage(audio.currentTime)
      });
 });