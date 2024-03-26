    event ItemPurchased(uint256 indexed id, string name, uint256 price, address buyer);

    constructor(uint256 _tokenPrice) {
        owner = msg.sender;
        tokenPrice = _tokenPrice;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function listItem(string memory _name, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");

        uint256 itemId = nextItemId++;
        items[itemId] = Item(itemId, msg.sender, _name, _price, true);
        numItems++;

        emit ItemListed(itemId, _name, _price, msg.sender);
    }

    function purchaseItem(uint256 _itemId) public payable {
        require(_itemId < nextItemId, "Item does not exist");
        Item storage item = items[_itemId];
        require(item.available, "Item is not available");
        require(msg.value >= item.price, "Insufficient funds");

        item.available = false;
        item.seller.transfer(item.price);
        emit ItemPurchased(_itemId, item.name, item.price, msg.sender);
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}

