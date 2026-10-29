let video = document.querySelector(".video-container video");
let texts  = document.querySelectorAll(".animated-text");

function selectVideo(id) {
  console.log(".video-" + id);
  video = document.querySelector(".video-" + id);
}
function selectTexts(id) {
  texts  = document.querySelectorAll(".video-" + id + "-text");
}



function setPlayState(id, state) {
  selectTexts(id);
  texts.forEach((t) => (t.style.animationPlayState = state));
}

function zoomTo(id, position, scale = 2) {
  selectVideo(id);
  video.style.transformOrigin = position;
  video.style.transform = `scale(${scale})`;
}

function resetZoom(id) {
  selectVideo(id);
  video.style.transform = "scale(1)";
}

function play(id) {
  selectVideo(id);
  if (video.ended || video.currentTime === 0) {
    video.currentTime = 0;
    restartAnimation(id);
  } else {
    setPlayState(id, "running");
  }
  video.play();
  video.addEventListener("ended", () => setPlayState(id, "paused"))
}

function stop(id) {
  selectVideo(id);
  video.pause();
  setPlayState(id, "paused");
}

function restartAnimation(id) {
  selectTexts(id);
  texts.forEach((t) => (t.style.animation = "none"));
  void document.body.offsetWidth;
  texts.forEach((t) => {
    t.style.animation = "";
    t.style.animationPlayState = "running";
  });
}



window.play = play;
window.stop = stop;
window.zoomTo = zoomTo;
window.resetZoom = resetZoom;