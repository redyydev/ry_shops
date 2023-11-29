window.addEventListener("message", function (event) {
    var action = event.data.action
    var data = event.data.data
  
    if (action == "openMenu") {
      openMenu(data.shopItems, data.shopName, data.categorys, data.useBlackMoney)
    } else if (action == "closeMenu") {
      $(".ui").fadeOut();
    }
  });
  
  $(document).ready(function () {
    $("body").on("keyup", function (key) {
      if (Config.closeKeys.includes(key.which)) {
        closeMenu();
      }
    });

    
});
