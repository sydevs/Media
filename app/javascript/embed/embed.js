
class SahajMediaEmbed {

  constructor() {
    console.log('sahaj media init')
    const audio = document.querySelector('audio')
    const images = document.querySelectorAll('.sym-media__image-stack > img')
    const time = document.querySelector('.sym-media__time')
    const track = document.querySelector('.sym-media__track')

    let activeImage = images[0]

    audio.ontimeupdate = function() {
      const fraction = audio.currentTime / audio.duration
      const angle = fraction * 360
      let newImage = null
      time.innerText = new Date(audio.currentTime * 1000).toISOString().substring(14, 19)
      track.style = `background-image: conic-gradient(#1E6C71 ${angle}deg, transparent ${angle}deg)`

      for (let i in images) {
        if (!newImage || Number(images[i].dataset.seconds) < audio.currentTime) {
          newImage = images[i]
        } else {
          break
        }
      }

      if (activeImage != newImage) {
        activeImage.classList.remove('active')
        newImage.classList.add('active')
        activeImage = newImage
      }
    }
  }

}

document.addEventListener('DOMContentLoaded', function() {
  window.SahajMedia = new SahajMediaEmbed()
})

console.log('load embed.js')