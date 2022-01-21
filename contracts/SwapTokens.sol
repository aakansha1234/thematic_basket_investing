// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface UniswapV2Factory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface UniswapV2Pair {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
}
interface IUniswapV2Router {

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
  external
  payable
  returns (uint[] memory amounts);
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
}

contract SwapTokens {
    address private factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address private uni = 0xC8F88977E21630Cf93c02D02d9E8812ff0DFC37a;
    address private weth = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
    address private UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address owner;
    // IUniswapV2Router02 uniswapV2Router= IUniswapV2Router02(UNISWAP_V2_ROUTER);
    IUniswapV2Router uniswapV2Router; 

    constructor  (address _uniswapV2Router)  {
        owner = msg.sender;
        uniswapV2Router = IUniswapV2Router(_uniswapV2Router); 
    }

    function getTokenReserves() external view returns (uint, uint) {
        address pair = UniswapV2Factory(factory).getPair(uni, weth);
        (uint reserve0, uint reserve1, ) = UniswapV2Pair(pair).getReserves();
        return (reserve0, reserve1);
    }

    function swap( address _tokenOut,  uint _amountOutMin,address _to) external payable{
        
        address _tokenIn=weth;
        // IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);

        IERC20(_tokenIn).approve(UNISWAP_V2_ROUTER, msg.value);
        
        address[] memory path;
        // if (_tokenIn == weth || _tokenOut == weth) {
        //     path = new address[](2);
        //     path[0] = _tokenIn;
        //     path[1] = _tokenOut;
        // } else {
        //     path = new address[](3);
        //     path[0] = _tokenIn;
        //     path[1] = weth;
        //     path[2] = _tokenOut;
        // }
        path = new address[](2);
        path[0]=weth;
        path[1]=_tokenOut;

        // uniswapV2Router.swapExactTokensForTokens

        uniswapV2Router.swapExactETHForTokens{value: msg.value}(
            _amountOutMin,
            path,
            msg.sender, //to be replaced by the address of the user
            block.timestamp
        );
    }

    receive() external payable { }
    
}