// Listens for messages from the server and performs the action requested
window.addEventListener("message", function (event) {
  var action = event.data.action
  var data = event.data.data

  // If the action is to open the menu, open the menu
  if (action == "openMenu") {
    openMenu(data.shopItems, data.shopName, data.categorys, data.useBlackMoney)
  } 
  // If the action is to close the menu, close the menu
  else if (action == "closeMenu") {
    $(".ui").fadeOut();
  }
});

// When the document is ready, add a keyup listener to the body
$(document).ready(function () {
  // If the key pressed is in the list of keys to close the menu, close the menu
  $("body").on("keyup", function (key) {
    if (Config.closeKeys.includes(key.which)) {
      closeMenu();
    }
  });
});

