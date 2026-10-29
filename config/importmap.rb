# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "gsap", to: "gsap.js"
# pin "gsap/ScrollTrigger", to: "gsap-ScrollTrigger.js"
# pin "gsap/ScrambleTextPlugin", to: "gsap-ScrambleTextPlugin.js"
# pin "gsap/SplitText", to: "gsap-SplitText.js"
pin "gsap", to: "https://cdn.jsdelivr.net/npm/gsap@3/index.js"
pin "gsap/SplitText", to: "https://cdn.jsdelivr.net/npm/gsap@3/SplitText.js"
pin "gsap/ScrambleTextPlugin", to: "https://cdn.jsdelivr.net/npm/gsap@3/ScrambleTextPlugin.js"

pin "gsap_client"
pin "animations"