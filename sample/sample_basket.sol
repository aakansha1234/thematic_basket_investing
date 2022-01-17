pragma solidity ^0.8.0;

contract Basket{

    address Owner;
    constructor() {
      Owner = msg.sender;
   }

    struct basket{
        string BasketID; //hash of the constituents of basket and weights
        mapping(string=>uint256) constituents; //mapping of coin to the weights(0.2 = 20 to avoid floating point)
        address ownerBasket;
    }

    mapping (address=>basket) user; //mapping of users subscribed to the BasketID


   
    //function createBasket(string[] tokens, uint256[] wieghts)

    //function returnBasket() returns basket{

}

/**
    1. We want this contract to be just a container for the new baskets proposed.
    2. This should only contain the methods to create and return the basket(struct) to be used by other contracts.
    3. Subscriptions and rewards  should be part of different contracts.
    4. Feel free to add other methods/checks which you think will be required for the template.
**/