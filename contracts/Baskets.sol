pragma solidity ^0.8.0;
import '@openzeppelin/contracts/access/Ownable.sol';

contract Baskets is Ownable{

    event basketCreated(address owner, Basket basket);

    mapping (address=>Basket[]) creators; //mapping of creators to the baskets created by them
    mapping (string=>Basket) uniqueBasketMapping; //mapping of basketId to Basket

    struct Basket {
        bool active;
        string BasketID; //hash of the constituents of basket and weights
        string[] tokens;
        uint256[] weights;
        address basketOwner;
    }

    modifier validateBasket(string[] memory tokens, uint256[] memory weights, string memory id){
        require(tokens.length == weights.length,"all tokens have not been assigned weights");
        require(!uniqueBasketMapping[id].active, "identical basket already exists");
        uint256 sum=0;
        for (uint i=0;i<weights.length;i++){
            sum+=weights[i];
        }
        require(sum==100,"sum of weights of constituents is not equal to 100");
        _;
   }
   
    function createBasket(string[] memory tokens, uint256[] memory weights, string memory id) external validateBasket(tokens,weights,id){

        Basket memory basket = Basket({BasketID:id,tokens:tokens, weights:weights,basketOwner:msg.sender, active: true});

        
        uniqueBasketMapping[id]= basket; //create a mapping for unique baskets
        creators[msg.sender].push(basket); //append to the list of baskets for the particular creator

        emit basketCreated(msg.sender, basket);
    }


    function getBasketById(string memory id) external view returns(Basket memory){
        require(uniqueBasketMapping[id].active, "basket does not exists");
        return uniqueBasketMapping[id];
    }

    function transferBasketOwnership(address _newOwner, string memory basketId) external{
        require(msg.sender == uniqueBasketMapping[basketId].basketOwner, "you are not the owner of the basket");
        uniqueBasketMapping[basketId].basketOwner = _newOwner;
        emit OwnershipTransferred(msg.sender, _newOwner);
    }

}



/**
    1. We want this contract to be just a container for the new baskets proposed.
    2. This should only contain the methods to create and return the basket(struct) to be used by other contracts.
    3. Subscriptions and rewards  should be part of different contracts.
    4. Feel free to add other methods/checks which you think will be required for the template.
**/