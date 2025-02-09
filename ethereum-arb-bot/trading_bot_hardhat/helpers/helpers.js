const ethers = require("ethers")
const Big = require('big.js')

async function getTokenAndContract(_token0Address, _token1Address, _provider) {
    const token0Contract = new ethers.Contract(_token0Address, IERC20.abi, _provider)
    const token1Contract = new ethers.Contract(_token1Address, IERC20.abi, _provider)

    const token0 = {
        address: _token0Address,
        decimals: 18,
        symbol: await token0Contract.symbol(),
        name: await token0Contract.name()
    }

    const token1 = {
        address: _token1Address,
        decimals: 18,
        symbol: await token1Contract.symbol(),
        name: await token1Contract.name()
    }

    return { token0Contract, token1Contract, token0, token1 }
}

async function calculatePrice(_pairContract) {
    const reserves = await _pairContract.getReserves()
    return Big(reserves.reserve0).div(Big(reserves.reserve1))
}

module.exports = {
    getTokenAndContract,
    calculatePrice
}
