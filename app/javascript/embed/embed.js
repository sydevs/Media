
class SahajMediaEmbed {

  constructor() {
    console.log('sahaj media init')
    const audio = document.querySelector('audio')
    const images = document.querySelectorAll('.sym-media__image-stack > img')
    const time = document.querySelector('.sym-media__time')
    const track = document.querySelector('.sym-media__track')
    const marker = document.querySelector('.sym-media__marker')

    let activeImage = images[0]

    audio.ontimeupdate = function() {
      const fraction = audio.currentTime / audio.duration
      const degrees = fraction * 360
      const radians = (fraction * 2 - 0.5) * Math.PI
      let newImage = null
      time.innerText = new Date(audio.currentTime * 1000).toISOString().substring(14, 19)
      track.style = `background-image: conic-gradient(#1E6C71 ${degrees}deg, transparent ${degrees}deg)`
      marker.style.left = `calc(50% + ${50 * Math.cos(radians)}% - 4px)`
      marker.style.top = `calc(50% + ${50 * Math.sin(radians)}% - 4px)`
      marker.style.opacity = fraction > 0.995 ? 0 : 1

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