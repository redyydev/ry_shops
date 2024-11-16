const cache = {
  basket: [],
  shopItems: [],
  totalCheckout: 0,
  inCheckout: false,
  paymentOption: null,
  useBlackMoney: false,
  texts: {}
};

/**
 * Opens the menu UI and initializes the shop state.
 * @function openMenu
 * @param {object[]} shopItems - Array of shop items to display.
 * @param {string} shopName - The name of the shop.
 * @param {string[]} categories - List of categories to display.
 * @param {boolean} useBlackMoney - Whether or not to use black money.
 */
function openMenu(shopItems, shopName, categories, useBlackMoney) {
  // Display the UI
  $(".ui").fadeIn();

  // Set the shop title
  $("#shopTitle").html(shopName);

  // Setup categories, items, and search functionality
  setupCategories(categories);
  setupShopItems(shopItems);
  setupSearch(shopItems);

  // Initialize cache values
  cache.useBlackMoney = useBlackMoney;
  cache.inCheckout = false;

  // Clear the basket
  clearBasket();

  // Show "No products added" message if the basket is empty
  if (!cache.basket.length) $("#noProductsAdded").fadeIn();
}

/**
 * Sets up the categories in the shop.
 * @function setupCategories
 * @param {string[]} categories - The list of categories to display.
 */
function setupCategories(categories) {
  // Get the shop categories container
  const shopCategories = $("#shopCategorys");

  // Clear any existing categories
  shopCategories.html("");

  // Add the "All" category with a reset function
  shopCategories.append(`
    <div class="shopCategory" id="category-all" onclick="resetCategory()">All</div>
  `);

  // Iterate over each category in the categories list
  categories.forEach((category) => {
    const categoryID = `category-${category}`;

    // Append each category to the shop categories container
    shopCategories.append(`
      <div class="shopCategory" id="${categoryID}">${category}</div>
    `);

    // Add a click event listener to each category
    $(`#${categoryID}`).click(() => {
      if (!cache.inCheckout) searchByCategory(category);
    });
  });
}

/**
 * Filters the shop items by category.
 * @function searchByCategory
 * @param {string} category The category to filter by.
 */
function searchByCategory(category) {
  // Remove the active class from all categories
  $(".shopCategory").removeClass("active");
  
  // Add the active class to the selected category
  $(`#category-${category}`).addClass("active");

  // Loop through the shop items and show/hide based on the category
  cache.shopItems.forEach((shopItem) => {
      const shopItemElement = $(`#shopItem-${shopItem.itemID}`);
      
      // If the item matches the category, show it, otherwise hide it
      if (shopItem.itemCategory === category) {
          shopItemElement.show();
      } else {
          shopItemElement.hide();
      }
  });
}

/**
 * Resets the shop categories to show all items.
 * @function resetCategory
 */
function resetCategory() {
  // Remove the active class from all categories
  $(".shopCategory").removeClass("active");
  
  // Add the active class to the 'All' category
  $("#category-all").addClass("active");

  // Show all shop items
  cache.shopItems.forEach((shopItem) => {
      $(`#shopItem-${shopItem.itemID}`).show();
  });
}

/**
 * Sets up the shop items container.
 * @function setupShopItems
 * @param {object[]} shopItems - The shop items.
 */
function setupShopItems(shopItems) {
  const shopItemsContainer = $("#shopItems");
  shopItemsContainer.html("");
  cache.shopItems = shopItems;

  // Loop through the shop items
  shopItems.forEach((shopItem) => {
    const shopItemID = `shopItem-${shopItem.itemID}`;
    // Check if the item is already in the container
    if (!$(`#${shopItemID}`).hasClass('item-set')) {
      // Add the item to the container
      shopItemsContainer.append(`
        <div class="shopItem vov fade-in infinite item-set" id="${shopItemID}">
          <div class="shopItem-Header">${shopItem.itemPrice}$</div>
          <div class="shopItem-Image">
            <img src="assets/${shopItem.itemImage}" />
          </div>
          <div class="shopItem-Footer" style="margin-left: 40px; margin-top: 35px">${shopItem.itemLabel}</div>
        </div>
      `);

      // Add a click event to the item
      $(`#${shopItemID}`).click(() => {
        // Check if we are not in the checkout
        if (!cache.inCheckout) {
          // Add the item to the basket
          addToBasket(shopItem);
        }
      });
    }
  });
}


/**
 * Adds an item to the basket.
 * @function addToBasket
 * @param {object} shopItem - The shop item to add.
 */
function addToBasket(shopItem) {
  // Hide the "No products added" message
  $("#noProductsAdded").hide();
  
  // Search the shop item in the basket
  let searchShopItem = cache.basket.find((product) => product.itemID === shopItem.itemID);

  // If the item is already in the basket, increase the quantity
  if (searchShopItem) {
    searchShopItem.itemQuantity++;
    searchShopItem.itemTotal += shopItem.itemPrice;

    // Update the UI
    updateBasketItemUI(searchShopItem);
  } else {
    // If the item is not in the basket, add it
    searchShopItem = Object.assign({}, shopItem, {
      itemQuantity: 1,
      itemTotal: shopItem.itemPrice,
    });

    // Add the item to the basket
    cache.basket.push(searchShopItem);

    // Append the item to the basket UI
    appendBasketItemUI(shopItem);
  }
  // Update the total checkout price
  updateTotalCheckout(shopItem.itemPrice);
}

/**
 * Updates the quantity and price of a basket item in the UI.
 * @function updateBasketItemUI
 * @param {object} item - The item to update.
 */
function updateBasketItemUI(item) {
  // Update the quantity
  $(`#basketItem-Quantity-${item.itemID}`).html(`x${item.itemQuantity}`);

  // Update the price
  $(`#basketItem-Price-${item.itemID}`).html(`${item.itemTotal}$`);
}

/**
 * Appends a new item to the basket UI.
 * @function appendBasketItemUI
 * @param {object} shopItem - The shop item to append.
 */
function appendBasketItemUI(shopItem) {
  const backgroundStyle = cache.useBlackMoney ? "rgba(255, 84, 84, 0.7)" : "rgba(56, 168, 5, 0.71)";
  $("#basketItems").append(`
    <div class="basketItem vov slide-in-up infinite" id="basketItem-${shopItem.itemID}">
      <div class="basketItem-Image"><img src="assets/${shopItem.itemImage}" /></div>
      <div class="basketItem-header">${shopItem.itemLabel}<span id="basketItem-Quantity-${shopItem.itemID}" style="margin-left: 5px;">x1</span></div>
      <div class="basketItem-footer"><span style="background: ${backgroundStyle}" id="basketItem-Price-${shopItem.itemID}">${shopItem.itemPrice}$</span></div>
    </div>
  `);

  // Add event listeners to the basket item
  $(`#basketItem-${shopItem.itemID}`).click(() => {
    if (!cache.inCheckout) removeFromBasket(shopItem);
  });

  $(`#basketItem-${shopItem.itemID}`).on("contextmenu", (e) => {
    if (!cache.inCheckout) removeFromBasketCompletamente(shopItem);
  });
}

/**
 * Removes all items of a given shop item from the basket.
 * @function removeFromBasketCompletamente
 * @param {object} shopItem - The shop item to remove.
 *
 * This function removes all items of the given shop item from the basket.
 * It also updates the total checkout price and removes the item from the UI.
 */
function removeFromBasketCompletamente(shopItem) {
  // Find the item in the basket
  const basketItem = cache.basket.find(item => item.itemID === shopItem.itemID);

  if (basketItem) {
    // Update the total checkout price
    updateTotalCheckout(-basketItem.itemTotal);

    // Remove the item from the basket
    cache.basket = cache.basket.filter(item => item.itemID !== shopItem.itemID);

    // Remove the item from the UI
    $(`#basketItem-${shopItem.itemID}`).remove();

    // Check if the basket is empty
    if (cache.basket.length === 0) {
      // Show the "No products added" message
      $("#noProductsAdded").fadeIn();
    }
  }
}

function updateTotalCheckout(amount) {
  cache.totalCheckout += amount;
  $("#totalcheckout").html(`${cache.totalCheckout}$`);
}

/**
 * Removes one item from the basket.
 * @function removeFromBasket
 * @param {object} shopItem - The shop item to remove.
 */
function removeFromBasket(shopItem) {
  // Search the shop item in the basket
  const searchShopItem = cache.basket.find((product) => product.itemID === shopItem.itemID);

  if (searchShopItem) {
    // Decrease the item quantity
    searchShopItem.itemQuantity--;
    // Decrease the item total price
    searchShopItem.itemTotal -= shopItem.itemPrice;
    // Update the UI
    updateBasketItemUI(searchShopItem);

    // If the item quantity is 0, remove it from the basket
    if (searchShopItem.itemQuantity === 0) {
      cache.basket = cache.basket.filter(item => item.itemID !== shopItem.itemID);
      // Remove the item HTML element
      $(`#basketItem-${shopItem.itemID}`).remove();
    }
    // Update the total checkout price
    updateTotalCheckout(-shopItem.itemPrice);

    // If the total checkout price is 0, show the "No products added" message
    if (cache.totalCheckout === 0) {
      $("#noProductsAdded").fadeIn();
    }
  }
}

/**
 * Proceeds to checkout.
 * @function proceedCheckout
 */
function proceedCheckout() {
  // Check if the total checkout amount is greater than 0
  if (cache.totalCheckout > 0) {
    // If it is, toggle the checkout state
    toggleCheckoutState();
  } else {
    // If it is not, flash a message indicating that there are no products added to the basket
    flashNoProductsMessage();
  }
}

/**
 * Toggles the checkout mode.
 * @function toggleCheckoutState
 */
function toggleCheckoutState() {
  // If we are currently in checkout mode, exit it
  if (cache.inCheckout) {
    exitCheckoutMode();
  } 
  // If we are not in checkout mode, enter it
  else {
    enterCheckoutMode();
  }
  
  // Toggle the boolean value
  cache.inCheckout = !cache.inCheckout;
}

/**
 * Enters the checkout mode.
 * @function enterCheckoutMode
 */
function enterCheckoutMode() {
  // Clear the HTML of the more-btns element
  $("#more-btns").html("");
  // Get the current date
  const date = Date.now();
  // Declare the button template
  const btnTemplate = cache.useBlackMoney ? ["blackmoney"] : ["cash", "bank"];
  
  // Loop through the button template and create a new button for each type
  btnTemplate.forEach(type => {
    // Append the button template to the more-btns element
    $("#more-btns").append(`
      <button class="shopButtonCheckout-Btn vov slide-in-left infinite" id="${type}-${date}" style="width: 10%; height: 70px; display: none;">
        <i class="bi bi-${type === "blackmoney" ? "cash-stack" : "credit-card"}" style="font-size: 1.7em; color: ${type === "blackmoney" ? "rgba(255, 84, 84, 0.7)" : "inherit"};"></i>
      </button>
    `);
    // Show the button and add a click event to it
    $(`#${type}-${date}`).show().click(() => submitCheckout(type));
  });

  // Set the opacity of the UI elements to 0.5
  setUIOpacity(0.5);
  // Show the more-btns element
  $("#more-btns").show();
  // Update the text of the checkout button
  $("#checkout").html('CANCEL');
}

/**
 * Exits the checkout mode.
 * @function exitCheckoutMode
 */
function exitCheckoutMode() {
  // Reset the opacity of the UI elements
  setUIOpacity(1);
  // Reset the text of the checkout button
  $("#checkout").html('CHECKOUT');
  // Hide the additional buttons
  $("#more-btns").hide();
}

/**
 * Sets the opacity of the UI elements to the given value.
 * @param {number} opacity the opacity value (between 0 and 1)
 */
function setUIOpacity(opacity) {
  // Set the opacity of the shop categories, shop items, basket items, and clear basket button
  $("#shopCategorys, #shopItems, #basketItems, #shopSearch-ClearBasket").css("opacity", opacity);
}

let checkoutSent = false;
/**
 * Submits the checkout to the server.
 * @param {string} paymentType the type of payment used (cash, bank, blackmoney)
 */
function submitCheckout(paymentType) {
  // Prevent the checkout from being sent multiple times
  if (checkoutSent) return;
  checkoutSent = true;

  $.post(`http://${GetParentResourceName()}/goToCheckout`, JSON.stringify({
    // Total amount to be paid
    totalPayment: cache.totalCheckout,
    // Items in the basket
    basket: cache.basket,
    // Type of payment used
    paymentType,
    // Whether or not to use black money
    useBlackMoney: cache.useBlackMoney
  }));

  // Close the menu after checkout
  closeMenu();
}

/**
 * Flashes a message indicating that there are no products added to the basket.
 * Temporarily changes the color of the "no products" text to red and then reverts it to white.
 */
function flashNoProductsMessage() {
  const noProductsText = $("#noProductsAdded-Text");
  // Change text color to red
  noProductsText.css("color", "red");
  // Revert text color to white after 100 milliseconds
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

/**
 * Clear the basket and reset the total checkout amount.
 */
function clearBasket() {
  // Clear the basket.
  cache.basket = [];

  // Reset the total checkout amount.
  cache.totalCheckout = 0;

  // Clear the basket items UI.
  $("#basketItems").html('');

  // Show the "no products added" message.
  $("#noProductsAdded").fadeIn();

  // Reset the total checkout label.
  $("#totalcheckout").html(`0$`);
}

/**
 * Close the menu and reset the shop state.
 */
function closeMenu() {
  // Notify the server that the menu was closed.
  $.post(`http://${GetParentResourceName()}/CloseMenu`, JSON.stringify({}));

  // Reset the state of the shop.
  cache.basket = []; // empty the basket
  cache.shopItems = []; // remove all shop items
  cache.totalCheckout = 0; // reset the total checkout amount
  cache.inCheckout = false; // exit checkout mode
  cache.useBlackMoney = false; // disable black money

  // Reset the UI
  setUIOpacity(1); // set the opacity of the UI to 1
  $("#checkout").html('CHECKOUT'); // reset the text of the checkout button
  $(".shopButtonCheckout-Btn").hide(); // hide the checkout button
  $("#totalcheckout").html(`0$`); // reset the total checkout label
  $("#checkout").show(); // show the checkout button

  // Reset the checkout sent flag
  checkoutSent = false;
}
