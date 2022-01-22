pragma solidity ^0.8.0;

interface BasketsAPI {
    function isBucketActive(string memory) external returns (bool);
}

contract Subscribe {
    BasketsAPI baskets;
    address swapToken;

    struct Subscription {
        uint256 id; // subscription id
        address subscriber; // address which created this subscription
        uint256 amountInEth; // amount that the subscriber wants to spend
        uint256 interval; // the time interval of subscription
        uint256 nextBuyTime; // 
    }

    Subscription[] public subs;
    mapping(uint256 => bool) public subActive;
    constructor(address _baskets, address _swapToken) {
        baskets = BasketsAPI(_baskets);
        swapToken = _swapToken;
    }

    function subscribe(string memory _basketId, uint256 _eth, uint256 interval) external returns (uint256) {
        require(baskets.isBucketActive(_basketId), "Bucket is not active");
        require(interval >= 1000, "cannot be less than 1000"); // ensure some minimum time interval

        uint256 id = subs.length;
        subs.push(Subscription(id, msg.sender, _eth, interval, block.timestamp + interval));
        subActive[id] = true;
        return id;
    }

    function unsubscribe(uint256 _subId) external {
        require(subs[_subId].subscriber == msg.sender, "not your subscription");
        require(!subActive[_subId], "already unsubscribed");
        subActive[_subId] = false;
    }

    // we need to run a bot to regularly buy for subscriptions
    function buy(uint256 _subId) external {
        require(block.timestamp >= subs[_subId].nextBuyTime, "next buy time is in future");

        subs[_subId].nextBuyTime += subs[_subId].interval;
        // buy basket
    }
}