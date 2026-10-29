const video = document.querySelector(".video-container video");
const text  = document.querySelector(".animated-text");

function zoomTo(position, scale = 2) {
  video.style.transformOrigin = position;
  video.style.transform = `scale(${scale})`;
}

function resetZoom() {
  video.style.transform = "scale(1)";
}

function play() {
  if (video.ended || video.currentTime === 0) {
    video.currentTime = 0;
    restartAnimation();
  } else {
    text.style.animationPlayState = "running"; // resume after pause
  }
  video.play();
}

function stop() {
  video.pause();
  text.style.animationPlayState = "paused";
}

function restartAnimation() {
  text.style.animation = "none";
  void text.offsetWidth;
  text.style.animation = "";
  text.style.animationPlayState = "running";
}

video.addEventListener("ended", function () {
  text.style.animationPlayState = "paused";
});


window.play = play;
window.stop = stop;
window.zoomTo = zoomTo;
window.resetZoom = resetZoom;