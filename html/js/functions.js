var checkout = false;
var in_checkout = false;

function main_menu(products, shop_name) {
  $(".ui").fadeIn();
  $(".products").html("");

  $("#title_principal").html(`<h1>${shop_name}</h1>`);
  $.each(products, function (index, product) {
    if (product.available) {
      $(".products").append(`
      <div class="product" id="product-${product.id}">
          <div class="header">
            <div class="price">${product.price}$</div>
            <div class="image">
              <img src="assets/${product.image}" alt="${product.image}">
            </div>
          </div>
          <div class="footer">
              <div class="footer-title">${product.name}</div>
          </div>
      </div>
      `);
    } else {
      $(".products").append(`
      <div class="product disabled" id="product-${product.id}">
          <div class="header">
            <div class="price">${product.price}$</div>
            <div class="image">
              <img src="assets/${product.image}" alt="${product.image}">
            </div>
          </div>
          <div class="footer">
              <div class="footer-title">${product.name}</div>
          </div>
      </div>
      `);
    }
    $(`#product-${product.id}`).click(function () {
      if (!in_checkout) {
        if (product.available) {
          addBasket(
            product.id,
            product.name,
            product.item,
            product.image,
            product.price,
            product.type
          );
        } else {
          unsuccessfully(`#product-${product.id}`);
        }
      } else {
        unsuccessfully(`#product-${product.id}`);
      }
    });
  });
  $(`#checkout`).click(function () {
    if (basket.length >= 1) {
      $(`#checkout`).hide();
      $(`#checkout-out`).show();
      $(".basket").css("opacity", "0.7");
      $(".content").css("opacity", "0.7");
      $(".payout").show();
      in_checkout = true;
      checkout_btn();
    } else {
      notification("Basket is Empty.");
    }
  });
  $(`#checkout-out`).click(function () {
    $(`#checkout-out`).hide();
    $(`#checkout`).show();
    $(".basket").css("opacity", "1.0");
    $(".content").css("opacity", "1.0");
    $(".payout").hide();
    in_checkout = false;
  });
}

function checkout_btn() {
  $(`#cash`).click(function () {
    $.each(basket, function (index, product) {
      $.post(
        "https://ry_shops/checkout",
        JSON.stringify({
          name: product.name,
          item: product.item,
          quantity: product.quantity,
          total: product.total,
          type: product.type,
          payment: "cash",
        })
      );
      closeMenu();
    });
  });

  $(`#bank`).click(function () {
    $.each(basket, function (index, product) {
      $.post(
        "https://ry_shops/checkout",
        JSON.stringify({
          name: product.name,
          item: product.item,
          quantity: product.quantity,
          total: product.total,
          type: product.type,
          payment: "bank",
        })
      );
      closeMenu();
    });
  });
}

function addBasket(id, name, itema, image, price, type) {
  var item = basket.find((product) => product.id === id);
  if (item) {
    if (item.type == "weapon") {
      unsuccessfully(`#basket-${item.id}`);
    } else if (item.type == "item") {
      item.quantity = item.quantity + 1;
      item.total = item.total + price;
      total = total + price;

      $("#pay").html(`${total}$`);

      $(`#basket-${item.id}`).html("");
      $(`#basket-${item.id}`).append(`
          <div class="header">
                <div class="price">${item.total}$</div>
                <div class="image">
                  <img src="assets/${item.image}" alt="${item.image}">
                  <span id="basket-count">x${item.quantity}</span>
                </div>
              </div>
          <div class="footer">
            <div class="footer-title">${item.name}</div>
          </div>
          `);
      success(`#basket-${item.id}`);
    }
  } else {
    basket.push({
      id: id,
      name: name,
      item: itema,
      image: image,
      quantity: 1,
      total: price,
      price: price,
      type: type,
    });

    total = total + price;
    $("#pay").html(`${total}$`);

    $(".basket").append(`
    <div class="product-basket" id="basket-${id}">
        <div class="header">
          <div class="price">${price}$</div>
          <div class="image">
            <img src="assets/${image}" alt="${image}">
            <span id="basket-count">${type == "weapon" ? "" : "x1"}</span>
          </div>
        </div>
        <div class="footer">
        <div class="footer-title">${name}</div>
        </div>
    </div>
    `);
    success(`#basket-${id}`);
    $(`#basket-${id}`).click(function () {
      basket_product(id);
    });
  }
}

function basket_product(id) {
  var item = basket.find((product) => product.id === id);
  if (item) {
    if (!in_checkout) {
      item.quantity = item.quantity - 1;
      item.total = item.total - item.price;
      total = total - item.price;

      if (basket.length == 0) {
        $("#pay").html(`0$`);
      } else {
        $("#pay").html(`${total}$`);
      }

      if (item.quantity == 0) {
        var index = basket.indexOf(item);
        basket.splice(index, 1);

        $(`#basket-${item.id}`).remove();
      } else {
        $(`#basket-${item.id}`).html("");
        $(`#basket-${item.id}`).append(`
          <div class="header">
              <div class="price">${item.total}$</div>
              <div class="image">
                <img src="assets/${item.image}" alt="${item.image}">
                <span id="basket-count">x${item.quantity}</span>
              </div>
          </div>
          <div class="footer">
            <div class="footer-title">${item.name}</div>
          </div>
        `);
        unsuccessfully(`#basket-${item.id}`);
      }
    }
  }
}

function clean() {
  basket = [];
  total = 0;
  in_checkout = false;

  $(".basket").html("");
  $("#pay").html(`0$`);
  $(`#checkout-out`).hide();
  $(`#checkout`).show();
  $(".basket").css("opacity", "1.0");
  $(".content").css("opacity", "1.0");
  $(".payout").hide();
}

function success(id) {
  $(`${id}`).css("background", "rgba(74, 214, 39, 0.2)");
  setTimeout(function () {
    $(`${id}`).css("background", "rgba(87, 87, 87, 0.2)");
  }, 100);
}

function unsuccessfully(id) {
  $(`${id}`).css("background", "rgba(204, 60, 60, 0.2)");
  setTimeout(function () {
    $(`${id}`).css("background", "rgba(87, 87, 87, 0.2)");
  }, 100);
}
function notification(text) {
  $(".notification").fadeIn();
  $(".notification").css("right", "5%");
  $(".notification").html(`<i class="bi bi-bell"></i> ${text}`);
  setTimeout(function () {
    $(".notification").fadeOut();
  }, 3000);
}

function closeMenu() {
  $.post("http://ry_shops/CloseUI", JSON.stringify({}));
  clean();
}
