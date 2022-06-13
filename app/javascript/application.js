// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"

let audio, video, image, frames;
let currentFrame = 0;
let nextFrameTime = 0;

function updateMedia(curTime, seeked) {
    // console.log(currentFrame + " " + nextFrameTime);

    // if the user is seeking in the audio timeline, find the correct current and next frames 
    if (seeked) {
        for (var i = 0; i < frames.length; i++) {
            if (curTime < frames[i][1]) {
                currentFrame = i - 1;
                nextFrameTime = frames[i][1];
                break;
            }
        }
        // console.log("Updated : " + currentFrame + " " + nextFrameTime);
    }

    //boundary condition so that it doesnt go above the frame length
    if (currentFrame < frames.length - 1) {
        nextFrameTime = frames[currentFrame + 1][1];
    }

    // If the current time if greater than the next frame, move to next frame
    if (curTime > nextFrameTime) {
        if (currentFrame < frames.length - 1) {
            currentFrame++;
        }
    }

    // special condition for the first frame
    if (currentFrame == 0) {
        // check if the current link is a video or not
        if ((frames[currentFrame][0].substr(frames[currentFrame][0].length - 3) == 'mp4')) {
            if (video.src != frames[currentFrame][0]) {
                updateVideoElement(curTime);
            }
        } else {
            updateImageElement()
        }

    } else {
        // don't update the image and video until its time
        if ((curTime) < nextFrameTime && !seeked) {
            // console.log(nextFrameTime - curTime + ' returning');
            return
        } else {
            // check if the current link is a video or not
            if ((frames[currentFrame][0].substr(frames[currentFrame][0].length - 3) == 'mp4')) {
                if (video.src != frames[currentFrame][0] || seeked == true) {
                    updateVideoElement(curTime);
                }
            } else {
                updateImageElement();
            }
        }
    }
}

function updateVideoElement(curTime) {
    video.style.display = "block";
    video.src = frames[currentFrame][0];
    // console.log('video src change');
    let videoToSeek = curTime - frames[currentFrame][1];
    video.currentTime = videoToSeek;
    video.load();
    // console.log("video paused? " + video.paused);
    if (!audio.paused) {
        video.play();
    }
    image.style.display = "none";
    image.src = "";
}

function updateImageElement() {
    image.style.display = "block";
    video.style.display = "none";
    video.src = "";
    image.src = frames[currentFrame][0];
    // console.log(image);
    // console.log('image src change, not the first one, image src = ' + frames[currentFrame][0])
}

/* 
function updateImage(curTime) {
    for (let i = 0; i < frames.length; i++) {
        if (i == (frames.length - 1)) {
            if (curTime >= frames[i][1]) {
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
            }
        }
    }
}
*/

document.addEventListener("DOMContentLoaded", () => {
    // data is a global variable set from embed.html.slim
    frames = JSON.parse(data.replace(/&quot;/g, '"'))

    video = document.getElementById('med_video');
    audio = document.getElementById('med_audio');
    image = document.getElementById('med_img');
    // keep a temporary white background
    image.src = "http://www.meditatenepal.org/img/white.jpg";
    image.style.display = "none";
    video.style.display = "none";

    //sort the frames ascending order
    frames.sort(function (a, b) {
        return a[1] - b[1]
    });

    audio.addEventListener('timeupdate', (event) => {
        // debugger;
        updateMedia(audio.currentTime, false);
    });

    audio.addEventListener('play', (event) => {
        if (video.src != '') {
            video.play();
        }
    });

    audio.addEventListener('seeked', (event) => {
        // debugger;
        updateMedia(audio.currentTime, true);
    });
});