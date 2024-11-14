const cache = {
  basket: [],
  shopItems: [],
  totalCheckout: 0,
  inCheckout: false,
  paymentOption: null,
  useBlackMoney: false,
};

function openMenu(shopItems, shopName, categories, useBlackMoney) {
  $(".ui").fadeIn();
  $("#shopTitle").html(shopName);

  setupCategories(categories);
  setupShopItems(shopItems);
  setupSearch(shopItems);

  cache.useBlackMoney = useBlackMoney;
  cache.inCheckout = false;

  clearBasket();

  if (!cache.basket.length) $("#noProductsAdded").fadeIn();
}

function setupCategories(categories) {
  const shopCategories = $("#shopCategorys");
  shopCategories.html("");

  shopCategories.append(`
    <div class="shopCategory" id="category-all" onclick="resetCategory()">All</div>
  `);

  categories.forEach((category) => {
    const categoryID = `category-${category}`;
    shopCategories.append(`
      <div class="shopCategory" id="${categoryID}">${category}</div>
    `);

    $(`#${categoryID}`).click(() => {
      if (!cache.inCheckout) searchByCategory(category);
    });
  });
}

function setupShopItems(shopItems) {
  const shopItemsContainer = $("#shopItems");
  shopItemsContainer.html("");
  cache.shopItems = shopItems;

  shopItems.forEach((shopItem) => {
    const shopItemID = `shopItem-${shopItem.itemID}`;
    if (!$(`#${shopItemID}`).hasClass('item-set')) {
      shopItemsContainer.append(`
        <div class="shopItem vov fade-in infinite item-set" id="${shopItemID}">
          <div class="shopItem-Header">${shopItem.itemPrice}$</div>
          <div class="shopItem-Image">
            <img src="assets/${shopItem.itemImage}" />
          </div>
          <div class="shopItem-Footer">${shopItem.itemLabel}</div>
        </div>
      `);

      $(`#${shopItemID}`).click(() => {
        if (!cache.inCheckout) addToBasket(shopItem);
      });
    }
  });
}


function addToBasket(shopItem) {
  $("#noProductsAdded").hide();
  
  let searchShopItem = cache.basket.find((product) => product.itemID === shopItem.itemID);
  if (searchShopItem) {
    searchShopItem.itemQuantity++;
    searchShopItem.itemTotal += shopItem.itemPrice;
    updateBasketItemUI(searchShopItem);
  } else {
    searchShopItem = Object.assign({}, shopItem, {
      itemQuantity: 1,
      itemTotal: shopItem.itemPrice,
    });

    cache.basket.push(searchShopItem);
    appendBasketItemUI(shopItem);
  }
  updateTotalCheckout(shopItem.itemPrice);
}


function updateBasketItemUI(item) {
  $(`#basketItem-Quantity-${item.itemID}`).html(`x${item.itemQuantity}`);
  $(`#basketItem-Price-${item.itemID}`).html(`${item.itemTotal}$`);
}

function appendBasketItemUI(shopItem) {
  const backgroundStyle = cache.useBlackMoney ? "rgba(255, 84, 84, 0.7)" : "rgba(56, 168, 5, 0.71)";
  $("#basketItems").append(`
    <div class="basketItem vov slide-in-up infinite" id="basketItem-${shopItem.itemID}">
      <div class="basketItem-Image"><img src="assets/${shopItem.itemImage}" /></div>
      <div class="basketItem-header">${shopItem.itemLabel}<span id="basketItem-Quantity-${shopItem.itemID}" style="margin-left: 5px;">x1</span></div>
      <div class="basketItem-footer"><span style="background: ${backgroundStyle}" id="basketItem-Price-${shopItem.itemID}">${shopItem.itemPrice}$</span></div>
    </div>
  `);

  $(`#basketItem-${shopItem.itemID}`).click(() => {
    if (!cache.inCheckout) removeFromBasket(shopItem);
  });
}

function updateTotalCheckout(amount) {
  cache.totalCheckout += amount;
  $("#totalcheckout").html(`${cache.totalCheckout}$`);
}

function removeFromBasket(shopItem) {
  const searchShopItem = cache.basket.find((product) => product.itemID === shopItem.itemID);

  if (searchShopItem) {
    searchShopItem.itemQuantity--;
    searchShopItem.itemTotal -= shopItem.itemPrice;
    updateBasketItemUI(searchShopItem);

    if (searchShopItem.itemQuantity === 0) {
      cache.basket = cache.basket.filter(item => item.itemID !== shopItem.itemID);
      $(`#basketItem-${shopItem.itemID}`).remove();
    }
    updateTotalCheckout(-shopItem.itemPrice);
  
    if (cache.totalCheckout === 0) {
      $("#noProductsAdded").fadeIn();
    }
  }
}

function proceedCheckout() {
  if (cache.totalCheckout > 0) {
    toggleCheckoutState();
  } else {
    flashNoProductsMessage();
  }
}

function toggleCheckoutState() {
  if (cache.inCheckout) {
    exitCheckoutMode();
  } else {
    enterCheckoutMode();
  }
  cache.inCheckout = !cache.inCheckout;
}

function enterCheckoutMode() {
  $("#more-btns").html("");
  const date = Date.now();
  const btnTemplate = cache.useBlackMoney ? "blackmoney" : ["cash", "bank"];
  
  (Array.isArray(btnTemplate) ? btnTemplate : [btnTemplate]).forEach(type => {
    $("#more-btns").append(`
      <button class="shopButtonCheckout-Btn vov slide-in-left infinite" id="${type}-${date}" style="width: 10%; height: 70px; display: none;">
        <i class="bi bi-${type === "bank" ? "credit-card" : "cash-stack"}" style="font-size: 1.7em; color: ${type === "blackmoney" ? "rgba(255, 84, 84, 0.7)" : "inherit"};"></i>
      </button>
    `);
    $(`#${type}-${date}`).show().click(() => submitCheckout(type));
  });

  setUIOpacity(0.5);
  $("#checkout").html('CANCEL');
}

function exitCheckoutMode() {
  setUIOpacity(1);
  $("#checkout").html('CHECKOUT');
}

function setUIOpacity(opacity) {
  $("#shopCategorys, #shopItems, #basketItems, #shopSearch-ClearBasket").css("opacity", opacity);
}

let checkoutSent = false;
function submitCheckout(paymentType) {
    if (checkoutSent) return; 
    checkoutSent = true;
    
    $.post("https://ry_shops/goToCheckout", JSON.stringify({
      totalPayment: cache.totalCheckout,
      basket: cache.basket,
      paymentType,
      useBlackMoney: cache.useBlackMoney
    }));

    closeMenu()
}



function flashNoProductsMessage() {
  const noProductsText = $("#noProductsAdded-Text");
  noProductsText.css("color", "red");
  setTimeout(() => noProductsText.css("color", "white"), 100);
}

function setupSearch(shopItems) {
  const searchInput = $("#shopSearch-Input");

  searchInput.on("input", () => {
    const searchValue = searchInput.val().toLowerCase();

    shopItems.forEach(({ itemID, itemLabel }) => {
      const shouldDisplay = itemLabel.toLowerCase().startsWith(searchValue);
      $(`#shopItem-${itemID}`).toggle(shouldDisplay);
    });
  });
}

function clearBasket() {
  cache.basket = [];
  cache.totalCheckout = 0;
  $("#basketItems").html("");
  $("#noProductsAdded").fadeIn();
  $("#totalcheckout").html(`0$`);
}

function closeMenu() {
  $.post("http://ry_shops/CloseMenu", JSON.stringify({}));

  cache.basket = [];
  cache.shopItems = [];
  cache.totalCheckout = 0;
  cache.inCheckout = false;
  cache.useBlackMoney = false;

  setUIOpacity(1);
  $("#checkout").html('CHECKOUT');
  $(".shopButtonCheckout-Btn").hide();
  $("#totalcheckout").html(`0$`);
  $("#checkout").show();

  checkoutSent = false;
}
