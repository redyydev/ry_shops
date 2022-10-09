var basket = [];
var total = 0;

window.addEventListener("message", function (event) {
    if (event.data.action == "open") {
        main_menu(event.data.content.products, event.data.content.shop_name)
    } else if (event.data.action == 'close') {
        $(".ui").fadeOut();
    } 
})

$(document).ready(function () {
  $("body").on("keyup", function (key) {
    if (Config.closeKeys.includes(key.which)) {
      closeMenu();
    }
  });
})