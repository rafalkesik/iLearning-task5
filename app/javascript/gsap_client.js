import { gsap } from "gsap"
import { SplitText } from "gsap/SplitText"
import { ScrambleTextPlugin } from "gsap/ScrambleTextPlugin"

const run = () => {
  const box = document.querySelector("#gsap-box")
  if (!box) return

  console.log("GSAP loaded, version:", gsap.version)
  gsap.to(box, { x: 300, rotation: 360, duration: 1.5, ease: "power2.inOut", repeat: -1, yoyo: true })


  gsap.registerPlugin(SplitText);

  let split = SplitText.create(".split", {
    type: "chars, words, lines"
  })

  gsap.from(split.chars, {
    // y: 100,
    yPercent: "random([-100, 100])",
    rotation: "random(-30, 30)",
    ease: "back.out",
    autoAlpha: 0,
    stagger: {
      each: 0.05,
      // amount: 0.5,
      from: "beggining",
      // from: "center",
      // from: "end",
      // from: "random",
    }
  })


  gsap.registerPlugin(ScrambleTextPlugin);

  const scrambleText = document.querySelector(".scramble")
  if (!scrambleText) return

  gsap.to('.scramble', {
    duration: 2, 
    scrambleText: {
      text: scrambleText.textContent,
      chars: 'XO'
    }
  });

  gsap.to('.tri', {
    rotation: 720,
    duration: 1,
    // ease: "bounce.out"
  });
}

document.addEventListener("turbo:load", run)
run()