var cache = {
  basket: [],
  shopItems: [],
  totalCheckout: 0,
  inCheckout: false,
  paymentOption: null
}

function openMenu(shopItems, shopName, categorys) {
  $(".ui").fadeIn();
  $("#shopTitle").html(shopName)

  cache.basket = []
  cache.shopItems = []
  cache.totalCheckout = 0
  cache.inCheckout = false

  setupCategorys(categorys)
  setupShopItems(shopItems)
  setupSearch(shopItems)

  $("#checkout").html('CHECKOUT')
  
  $("#checkout").css("opacity", "1.0")
  $("#shopCategorys").css("opacity", "1.0")
  $("#shopItems").css("opacity", "1.0")
  $("#basketItems").css("opacity", "1.0")

  $(`.shopButtonCheckout-Btn`).hide()
  $(`#checkout`).show()

  if (!cache.basket.length)
  $("#noProductsAdded").fadeIn()
}

function setupCategorys(categorys) {
  $("#shopCategorys").html("")

  $("#shopCategorys").append(`
    <div class="shopCategory" id="category-all" onclick="resetCategory()">All</div>
  `)

  categorys.forEach(function(category) {
    $("#shopCategorys").append(`
      <div class="shopCategory" id="category-${category}">${category}</div>
    `)
    
    $(`#category-${category}`).click(function() {
      if (!cache.inCheckout) 
      searchbyCategory(category)
    })
  })
}

function resetCategory() {
  if (!cache.inCheckout) 
  cache.shopItems.forEach(function (shopItem){
    $(`#shopItem-${shopItem.itemID}`).show();
  })
}

function searchbyCategory(category) {
  let regex = new RegExp(category);
    cache.shopItems.forEach(function (shopItem){
      $(`#shopItem-${shopItem.itemID}`).hide();
      if (shopItem.itemCategory.search(regex) > -1){   
          $(`#shopItem-${shopItem.itemID}`).show();
        }
    })
}

function setupShopItems(shopItems) {
  $("#shopItems").html("")
  $("#basketItems").html("")
  cache.shopItems = shopItems
  
  shopItems.forEach(function(shopItem) {
    $("#shopItems").append(`
    <div class="shopItem vov fade-in infinite" id="shopItem-${shopItem.itemID}">
      <div class="shopItem-Header">${shopItem.itemPrice}$</div>
      <div class="shopItem-Image">
        <img src="assets/${shopItem.itemImage}"
      </div>
      <div class="shopItem-Footer">${shopItem.itemLabel}</div>
    </div>
    `)

    $(`#shopItem-${shopItem.itemID}`).click(function() {
      if (!cache.inCheckout) 
      addtoBasket(shopItem)
    })
  })
}

function addtoBasket(shopItem) {
  $("#noProductsAdded").hide()

  var searchShopItem = cache.basket.find((product) => product.itemID === shopItem.itemID);

  if (searchShopItem) {
    searchShopItem.itemQuantity = searchShopItem.itemQuantity + 1
    searchShopItem.itemTotal = searchShopItem.itemPrice + searchShopItem.itemTotal
    $(`#basketItem-Quantity-${searchShopItem.itemID}`).html(`x${searchShopItem.itemQuantity}`)
    $(`#basketItem-Price-${searchShopItem.itemID}`).html(`${searchShopItem.itemTotal}$`)
  } else {
    cache.basket.push({
      itemID: shopItem.itemID,
			itemName: shopItem.itemName,
			itemLabel: shopItem.itemLabel,
			itemImage: shopItem.itemImage,
			itemPrice: shopItem.itemPrice,
			itemCategory: shopItem.itemCategory,
			itemQuantity: 1,
			itemTotal: shopItem.itemPrice
    })

    $("#basketItems").append(`
    <div class="basketItem vov fade-in infinite" id="basketItem-${shopItem.itemID}">
      <div class="basketItem-Header"><span id="basketItem-Price-${shopItem.itemID}">${shopItem.itemTotal}$</span> <span id="basketItem-Quantity-${shopItem.itemID}" style="float: right;">x${shopItem.itemQuantity}</span></div>
      <div class="basketItem-Image">
        <img src="assets/${shopItem.itemImage}"
      </div>
      <div class="basketItem-Footer">${shopItem.itemLabel}</div>
    </div>
    `)

    $(`#basketItem-${shopItem.itemID}`).click(function() {
      if (!cache.inCheckout) 
      removeFromBasket(shopItem)
    })
  }
  cache.totalCheckout = cache.totalCheckout + shopItem.itemPrice
  $(`#totalcheckout`).html(`${cache.totalCheckout}$`)
}

function removeFromBasket(shopItem) {
  var searchShopItem = cache.basket.find((product) => product.itemID === shopItem.itemID);

  if (searchShopItem) {
    if (searchShopItem.itemQuantity == 1) {
      var index = cache.basket.indexOf(searchShopItem);
      cache.basket.splice(index, 1)
      $(`#basketItem-${searchShopItem.itemID}`).remove();
    }
    if (searchShopItem.itemQuantity >= 2 ) {
      searchShopItem.itemQuantity = searchShopItem.itemQuantity - 1
      searchShopItem.itemTotal = searchShopItem.itemTotal - searchShopItem.itemPrice
      $(`#basketItem-Price-${searchShopItem.itemID}`).html(`${searchShopItem.itemTotal}$`)
      $(`#basketItem-Quantity-${searchShopItem.itemID}`).html(`x${searchShopItem.itemQuantity}`)
    }   
    cache.totalCheckout = cache.totalCheckout - searchShopItem.itemPrice
    $(`#totalcheckout`).html(`${cache.totalCheckout}$`)
  }

  if (cache.totalCheckout == 0 ) {
    $("#noProductsAdded").fadeIn()
  }

}

function proceedCheckout() {
  if (cache.totalCheckout >= 1) {
    $("#more-btns").html("")
    cache.inCheckout = !cache.inCheckout
    if (cache.inCheckout) {

      var date = Date.now()

      $("#more-btns").append(`
      <button class="shopButtonCheckout-Btn vov fade-in infinite" id="cash-${date}" style="width: 10%; height: 70px; display: none;"><i class="bi bi-cash-stack"  style="font-size: 1.7em;"></i></button>
      <button class="shopButtonCheckout-Btn vov fade-in infinite" id="bank-${date}"" style="width: 10%; height: 70px; display: none;"><i class="bi bi-credit-card" style="font-size: 1.7em;"></i></button>
      `)

      $("#checkout").html('CANCEL')
  
      $("#shopCategorys").css("opacity", "0.5")
      $("#shopItems").css("opacity", "0.5")
      $("#basketItems").css("opacity", "0.5")
      
      $(`#cash-${date}`).show()
      $(`#bank-${date}`).show()
      
      $(`#cash-${date}`).click(function() {
          $.post(
            "https://ry_shops/checkout",
            JSON.stringify({
              basket: cache.basket,
              payment: "cash",
            })
          );
        closeMenu();
      })
      
      $(`#bank-${date}`).click(function() {
        $.post(
          "https://ry_shops/checkout",
          JSON.stringify({
            basket: cache.basket,
            payment: "bank",
          })
        );
        closeMenu();
      })

    } else {
      $("#checkout").html('CHECKOUT')
  
      $("#checkout").css("opacity", "1.0")
      $("#shopCategorys").css("opacity", "1.0")
      $("#shopItems").css("opacity", "1.0")
      $("#basketItems").css("opacity", "1.0")
  
      $(`#cash-${cache.totalCheckout}`).hide()
      $(`#bank-${cache.totalCheckout}`).hide()
    }
  } else {
    $("#noProductsAdded-Text").css("color", "red")
    setTimeout(function () {
      $("#noProductsAdded-Text").css("color", "white")
    }, 100);
  }
}

function setupSearch(shopItems) {
  const searchInput = document.getElementById("shopSearch-Input");

  searchInput.addEventListener("input", (e) => {
    const searchValue = searchInput.value;

    if (!searchValue) {
      for (var i = 0; i < shopItems.length; i++) {
        var id = shopItems[i].itemID;
        $(`#shopItem-${id}`).show();
      }
    } else {
      for (var i = 0; i < shopItems.length; i++) {
        var name = shopItems[i].itemLabel;
        var id = shopItems[i].itemID;
        if (name.toLowerCase().indexOf(searchValue.toLowerCase())) {
          $(`#shopItem-${id}`).hide();
        } else {
          $(`#shopItem-${id}`).show();
        }
      }
    }
  });
}



































function closeMenu() {
  $.post("http://ry_shops/CloseMenu", JSON.stringify({}));
}