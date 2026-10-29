const video = document.querySelector(".video-container video");
const texts  = document.querySelectorAll(".animated-text");

function setPlayState(state) {
  texts.forEach((t) => (t.style.animationPlayState = state));
}

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
    setPlayState("running");
  }
  video.play();
}

function stop() {
  video.pause();
  setPlayState("paused");
}

function restartAnimation() {
  texts.forEach((t) => (t.style.animation = "none"));
  void document.body.offsetWidth;
  texts.forEach((t) => {
    t.style.animation = "";
    t.style.animationPlayState = "running";
  });
}

video.addEventListener("ended", () => setPlayState("paused"))

window.play = play;
window.stop = stop;
window.zoomTo = zoomTo;
window.resetZoom = resetZoom;