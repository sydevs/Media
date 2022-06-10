// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

let audio, video, image, frames;
let currentFrame = 0;
let nextFrame = 1;

function updateMedia(curTime) {
    // debugger;
    console.log(currentFrame + " " + nextFrame);
    if (currentFrame < frames.length-1) {
        nextFrame = frames[currentFrame + 1][1];
    }

    if ((frames[currentFrame][0].substr(frames[currentFrame][0].length - 3) == 'mp4')) {
        if (video.src != frames[currentFrame][0]) {
            video.style.display = "block";
            image.style.display = "none";
            video.src = frames[currentFrame][0];
            console.log('video src change')
        }
    } else {
        // debugger;
        image.style.display = "block";
        video.style.display = "none";
        image.src = frames[currentFrame][0];
    }
    if (curTime > nextFrame) {
        if (currentFrame < frames.length-1) {
            currentFrame++;
        }
    }
    // curTime > frames[i][1] && curTime < frames[i + 1][1]
    // if(frames[currentFrame][0] >= curTime ){

    // }

}

function updateImage(curTime) {
    // console.log(curTime);
    for (let i = 0; i < frames.length; i++) {
        if (i == (frames.length - 1)) {
            if (curTime >= frames[i][1]) {
                debugger;
                if ((frames[i][0].substr(frames[i][0].length - 3) == 'mp4')) {
                    if (video.src != frames[i][0]) {
                        video.style.display = "block";
                        image.style.display = "none";
                        video.src = frames[i][0];
                        console.log('video src change')
                    }


                } else {
                    image.style.display = "block";
                    video.style.display = "none";
                    image.src = frames[i][0];

                }

                // console.log(frames[i][0])
            }
        } else {
            if (curTime > frames[i][1] && curTime < frames[i + 1][1]) {
                // console.log('here');
                if ((frames[i][0].substr(frames[i][0].length - 3) == 'mp4')) {

                    if (video.src != frames[i][0]) {
                        video.src = frames[i][0];
                        video.load();
                        video.play();
                    }

                } else {
                    image.src = frames[i][0];
                }
                // console.log(frames[i][0])
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
    image.src = "http://www.meditatenepal.org/img/white.jpg";
    image.style.display = "none";
    video.style.display = "none";

    //sort the frames ascending order
    frames.sort(function (a, b) {
        return a[1] - b[1]
    });

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
        // updateImage(audio.currentTime);
        updateMedia(audio.currentTime);
    });

    audio.addEventListener('seeked', (event) => {
        // updateImage(audio.currentTime);
        debugger;
        updateMedia(audio.currentTime);
    });
});