function main_menu(products){
  $(".ui").fadeIn();
  $(".products").html('')

  $.each(products, function(index, product) {
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
      if (product.available) {
        addBasket(product.id, product.name, product.item, product.image, product.price, product.type);
      } else {
        unsuccessfully(`#product-${product.id}`);
      }
    })

  })
  $(`#pay`).click(function() {
    checkout()
  })
}

function checkout() {
  if (basket.length >= 1) {
    $.each(basket, function(index, product) {
      $.post('https://ry_shops/checkout', JSON.stringify({
          name: product.name,
          item: product.item,
          quantity: product.quantity,
          total: product.total,
          type: product.type
      }));
      closeMenu();
    })
  } else {
    notification('Basket is Empty')
  }
}

function clean() {
  basket = []
  total = 0
  $(".basket").html('')
  $(".basket").append('<div class="basket-title"><i class="bi bi-basket"></i> Shopping BASKET</div>')
  $("#pay").html(`Checkout (0$)`);
}

function addBasket(id, name, itema, image, price, type) {
  var item = basket.find(product => product.id === id);
  if (item) {
    if (item.type == 'weapon') {
      unsuccessfully(`#basket-${item.id}`)
    } else if (item.type == 'item') {
          item.quantity = item.quantity + 1;
          item.total = item.total + price;
          total = total + price;
      
          $("#pay").html(`Checkout (${total}$)`);
      
          $(`#basket-${item.id}`).html('');
          $(`#basket-${item.id}`).append(`
          <div class="header">
                <div class="price">${item.total}$</div>
                <div class="image">
                  <img src="assets/${item.image}" alt="${item.image}">
                </div>
              </div>
          <div class="footer">
            <div class="footer-title">${item.name} x${item.quantity}</div>
          </div>
          `);
          success(`#basket-${item.id}`);
    }
    } else {
    basket.push({id: id, name: name, item: itema, image: image, quantity: 1, total: price, price: price, type: type});

    total = total + price;
    $("#pay").html(`Checkout (${total}$)`);

    $(".basket").append(`
    <div class="product-basket" id="basket-${id}">
        <div class="header">
          <div class="price">${price}$</div>
          <div class="image">
            <img src="assets/${image}" alt="${image}">
          </div>
        </div>
        <div class="footer">
        <div class="footer-title">${name} ${type == 'weapon' ? "" : 'x1'}</div>
        </div>
    </div>
    `);
    success(`#basket-${id}`)
      $(`#basket-${id}`).click(function() {
          basket_product(id);
      })
  }
}

function basket_product(id){
  var item = basket.find(product => product.id === id);
  if (item) {
    item.quantity = item.quantity - 1;
    item.total = item.total - item.price;
    total = total - item.price;

    if (basket.length == 0) {
      $("#pay").html(`Checkout (0$)`);
    } else {
      $("#pay").html(`Checkout (${total}$)`);
    }

    if (item.quantity == 0) {
      var index = basket.indexOf(item);
      basket.splice(index, 1);
      
      $(`#basket-${item.id}`).remove();
    } else {
      $(`#basket-${item.id}`).html('')
      $(`#basket-${item.id}`).append(`
        <div class="header">
            <div class="price">${item.total}$</div>
            <div class="image">
              <img src="assets/${item.image}" alt="${item.image}">
            </div>
        </div>
        <div class="footer">
          <div class="footer-title">${item.name} x${item.quantity}</div>
        </div>
      `);
      unsuccessfully(`#basket-${item.id}`);
    }
  }
}

function success(id){
  $(`${id}`).css("background", "rgba(74, 214, 39, 0.2)");
  setTimeout(function() { $(`${id}`).css("background", "rgba(87, 87, 87, 0.2)") }, 100);
}

function unsuccessfully(id){
  $(`${id}`).css("background", "rgba(204, 60, 60, 0.2)");
  setTimeout(function() {$(`${id}`).css("background", "rgba(87, 87, 87, 0.2)")}, 100);
}
function notification(text) {
    $(".notification").fadeIn();
    $(".notification").css("right", "15%");
    $(".notification").html(`<i class="bi bi-bell"></i> ${text}`);
    setTimeout(function() {
      $(".notification").fadeOut();
  }, 2000)
}

function closeMenu() {
  $.post("http://ry_shops/CloseUI", JSON.stringify({}));
  clean()
}