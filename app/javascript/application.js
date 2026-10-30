// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

window.toggleRow = function (id) {
  document.getElementById(id).classList.toggle('hidden');
  document.getElementById("icon-" + id).classList.toggle('rotate-90');
}
