sudo apt update && sudo apt upgrade -y
# Update and upgrade system
sudo apt update && sudo apt upgrade -y
# Install Node.js (use NVM for best version management)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
# Install Node.js LTS
nvm install --lts
nvm use --lts
# Create a directory for the project
mkdir ethereum-arb-bot
cd ethereum-arb-bot
# Clone the repository
git clone <your-repository-url>
cd trading_bot_hardhat
# Install dependencies
npm install
# Create .env file
cp .env.example .env
# Edit .env file with your specific configurations
nano .env
npm install
nano config.json
npm install pm2 -g
pm2 start bot.js --name eth-arb-bot
pm2 logs eth-arb-bot
pwd
ls
# Clone the repository again
git clone <repository-url>
# Or copy files manually
git clone https://github.com/your-github-username/trading_bot_hardhat.git
cd trading_bot_hardhat
mkdir -p trading_bot_hardhat/helpers
cd trading_bot_hardhat
# Create bot.js
cat << 'EOF' > bot.js
const ethers = require("ethers")
const config = require('./config.json')
const { getTokenAndContract, getPairContract, getReserves, calculatePrice, simulate } = require('./helpers/helpers')
const { provider, uFactory, uRouter, sFactory, sRouter, arbitrage } = require('./helpers/initialization')

const arbFor = process.env.ARB_FOR
const arbAgainst = process.env.ARB_AGAINST
const units = process.env.UNITS
const difference = process.env.PRICE_DIFFERENCE
const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

let uPair, sPair, amount
let isExecuting = false

const main = async () => {
  const { token0Contract, token1Contract, token0, token1 } = await getTokenAndContract(arbFor, arbAgainst, provider)
  uPair = await getPairContract(uFactory, token0.address, token1.address, provider)
  sPair = await getPairContract(sFactory, token0.address, token1.address, provider)

  console.log(`Monitoring swap events for arbitrage...`)
  console.log(`Uniswap Pair: ${await uPair.getAddress()}`)
  console.log(`Sushiswap Pair: ${await sPair.getAddress()}`)

  uPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true
      // Arbitrage logic here
      isExecuting = false
    }
  })
}

main().catch(console.error)
EOF

# Create helpers/helpers.js
mkdir -p helpers
cat << 'EOF' > helpers/helpers.js
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
EOF

# Create helpers/initialization.js
cat << 'EOF' > helpers/initialization.js
const hre = require("hardhat")
require("dotenv").config()

const config = require('../config.json')
const IUniswapV2Router02 = require('@uniswap/v2-periphery/build/IUniswapV2Router02.json')
const IUniswapV2Factory = require("@uniswap/v2-core/build/IUniswapV2Factory.json")

let provider = new hre.ethers.WebSocketProvider(`wss://eth-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`)

const uFactory = new hre.ethers.Contract(config.UNISWAP.FACTORY_ADDRESS, IUniswapV2Factory.abi, provider)
const uRouter = new hre.ethers.Contract(config.UNISWAP.V2_ROUTER_02_ADDRESS, IUniswapV2Router02.abi, provider)
const sFactory = new hre.ethers.Contract(config.SUSHISWAP.FACTORY_ADDRESS, IUniswapV2Factory.abi, provider)
const sRouter = new hre.ethers.Contract(config.SUSHISWAP.V2
# Create bot.js
cat << 'EOF' > bot.js
const ethers = require("ethers")
const config = require('./config.json')
const { getTokenAndContract, getPairContract, getReserves, calculatePrice, simulate } = require('./helpers/helpers')
const { provider, uFactory, uRouter, sFactory, sRouter, arbitrage } = require('./helpers/initialization')

const arbFor = process.env.ARB_FOR
const arbAgainst = process.env.ARB_AGAINST
const units = process.env.UNITS
const difference = process.env.PRICE_DIFFERENCE
const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

let uPair, sPair, amount
let isExecuting = false

const main = async () => {
  const { token0Contract, token1Contract, token0, token1 } = await getTokenAndContract(arbFor, arbAgainst, provider)
  uPair = await getPairContract(uFactory, token0.address, token1.address, provider)
  sPair = await getPairContract(sFactory, token0.address, token1.address, provider)

  console.log(`Monitoring swap events for arbitrage...`)
  console.log(`Uniswap Pair: ${await uPair.getAddress()}`)
  console.log(`Sushiswap Pair: ${await sPair.getAddress()}`)

  uPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true
      // Arbitrage logic here
      isExecuting = false
    }
  })
}

main().catch(console.error)
EOF

# Create helpers/helpers.js
mkdir -p helpers
cat << 'EOF' > helpers/helpers.js
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
EOF

# Create helpers/initialization.js
cat << 'EOF' > helpers/initialization.js
const hre = require("hardhat")
require("dotenv").config()

const config = require('../config.json')
const IUniswapV2Router02 = require('@uniswap/v2-periphery/build/IUniswapV2Router02.json')
const IUniswapV2Factory = require("@uniswap/v2-core/build/IUniswapV2Factory.json")

let provider = new hre.ethers.WebSocketProvider(`wss://eth-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`)

const uFactory = new hre.ethers.Contract(config.UNISWAP.FACTORY_ADDRESS, IUniswapV2Factory.abi, provider)
const uRouter = new hre.ethers.Contract(config.UNISWAP.V2_ROUTER_02_ADDRESS, IUniswapV2Router02.abi, provider)
const sFactory = new hre.ethers.Contract(config.SUSHISWAP.FACTORY_ADDRESS, IUniswapV2Factory.abi, provider)
const sRouter = new hre.ethers.Contract(config.SUSHISWAP.V2_ROUTER_02_ADDRESS, IUniswapV2Router02.abi, provider)

module.exports = {
  provider,
  uFactory,
  uRouter,
  sFactory,
  sRouter
}
EOF

# Create .env file
cat << 'EOF' > .env
ALCHEMY_API_KEY=your_alchemy_api_key
ARB_FOR=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
ARB_AGAINST=0x95aD61b0a150d79219dCF64E1E6Cc01f0B64C4cE
PRIVATE_KEY=your_ethereum_wallet_private_key
PRICE_DIFFERENCE=0.50
UNITS=0
GAS_LIMIT=400000
GAS_PRICE=0.00000006
EOF

# Create config.json
cat << 'EOF' > config.json
{
    "PROJECT_SETTINGS": {
        "isLocal": false,
        "isDeployed": false,
        "ARBITRAGE_ADDRESS": ""
    },
    "UNISWAP": {
        "V2_ROUTER_02_ADDRESS": "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D",
        "FACTORY_ADDRESS": "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"
    },
    "SUSHISWAP": {
        "V2_ROUTER_02_ADDRESS": "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F",
        "FACTORY_ADDRESS": "0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac"
    }
}
EOF

# Create package.json
cat << 'EOF' > package.json
{
  "name": "ethereum-arbitrage-bot",
  "version": "1.0.0",
  "description": "Ethereum Arbitrage Trading Bot",
  "main": "bot.js",
  "scripts": {
    "start": "node bot.js"
  },
  "dependencies": {
    "big.js": "^6.2.1",
    "dotenv": "^16.0.3",
    "ethers": "^6.6.2",
    "hardhat": "^2.19.4"
  }
}
EOF

# Install dependencies
npm install
nano .env
# Replace placeholders with:
# - Your Alchemy WebSocket API key
# - Your Ethereum wallet private key
npm install ethers hardhat
mkdir -p helpers
cat << 'EOF' > bot.js
const ethers = require("ethers")
const config = require('./config.json')
const { getTokenAndContract, getPairContract, getReserves, calculatePrice, simulate } = require('./helpers/helpers')
const { provider, uFactory, uRouter, sFactory, sRouter, arbitrage } = require('./helpers/initialization')

const arbFor = process.env.ARB_FOR
const arbAgainst = process.env.ARB_AGAINST
const units = process.env.UNITS
const difference = process.env.PRICE_DIFFERENCE
const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

let uPair, sPair, amount
let isExecuting = false

const main = async () => {
  const { token0Contract, token1Contract, token0, token1 } = await getTokenAndContract(arbFor, arbAgainst, provider)
  uPair = await getPairContract(uFactory, token0.address, token1.address, provider)
  sPair = await getPairContract(sFactory, token0.address, token1.address, provider)

  console.log(`uPair Address: ${await uPair.getAddress()}`)
  console.log(`sPair Address: ${await sPair.getAddress()}\n`)

  uPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Uniswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  sPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Sushiswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  console.log("Waiting for swap event...")
}

const checkPrice = async (_exchange, _token0, _token1) => {
  isExecuting = true

  console.log(`Swap Initiated on ${_exchange}, Checking Price...\n`)

  const currentBlock = await provider.getBlockNumber()

  const uPrice = await calculatePrice(uPair)
  const sPrice = await calculatePrice(sPair)

  const uFPrice = Number(uPrice).toFixed(units)
  const sFPrice = Number(sPrice).toFixed(units)
  const priceDifference = (((uFPrice - sFPrice) / sFPrice) * 100).toFixed(2)

  console.log(`Current Block: ${currentBlock}`)
  console.log(`-----------------------------------------`)
  console.log(`UNISWAP   | ${_token1.symbol}/${_token0.symbol}\t | ${uFPrice}`)
  console.log(`SUSHISWAP | ${_token1.symbol}/${_token0.symbol}\t | ${sFPrice}\n`)
  console.log(`Percentage Difference: ${priceDifference}%\n`)

  return priceDifference
}

const determineDirection = async (_priceDifference) => {
  console.log(`Determining Direction...\n`)

  if (_priceDifference >= difference) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Uniswap`)
    console.log(`Sell\t -->\t Sushiswap\n`)
    return [uRouter, sRouter]
  } else if (_priceDifference <= -(difference)) {
    console.log(`Potential A
cat << 'EOF' > bot.js
const ethers = require("ethers")
const config = require('./config.json')
const { getTokenAndContract, getPairContract, getReserves, calculatePrice, simulate } = require('./helpers/helpers')
const { provider, uFactory, uRouter, sFactory, sRouter, arbitrage } = require('./helpers/initialization')

const arbFor = process.env.ARB_FOR
const arbAgainst = process.env.ARB_AGAINST
const units = process.env.UNITS
const difference = process.env.PRICE_DIFFERENCE
const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

let uPair, sPair, amount
let isExecuting = false

const main = async () => {
  const { token0Contract, token1Contract, token0, token1 } = await getTokenAndContract(arbFor, arbAgainst, provider)
  uPair = await getPairContract(uFactory, token0.address, token1.address, provider)
  sPair = await getPairContract(sFactory, token0.address, token1.address, provider)

  console.log(`uPair Address: ${await uPair.getAddress()}`)
  console.log(`sPair Address: ${await sPair.getAddress()}\n`)

  uPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Uniswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  sPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Sushiswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  console.log("Waiting for swap event...")
}

const checkPrice = async (_exchange, _token0, _token1) => {
  isExecuting = true

  console.log(`Swap Initiated on ${_exchange}, Checking Price...\n`)

  const currentBlock = await provider.getBlockNumber()

  const uPrice = await calculatePrice(uPair)
  const sPrice = await calculatePrice(sPair)

  const uFPrice = Number(uPrice).toFixed(units)
  const sFPrice = Number(sPrice).toFixed(units)
  const priceDifference = (((uFPrice - sFPrice) / sFPrice) * 100).toFixed(2)

  console.log(`Current Block: ${currentBlock}`)
  console.log(`-----------------------------------------`)
  console.log(`UNISWAP   | ${_token1.symbol}/${_token0.symbol}\t | ${uFPrice}`)
  console.log(`SUSHISWAP | ${_token1.symbol}/${_token0.symbol}\t | ${sFPrice}\n`)
  console.log(`Percentage Difference: ${priceDifference}%\n`)

  return priceDifference
}

const determineDirection = async (_priceDifference) => {
  console.log(`Determining Direction...\n`)

  if (_priceDifference >= difference) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Uniswap`)
    console.log(`Sell\t -->\t Sushiswap\n`)
    return [uRouter, sRouter]
  } else if (_priceDifference <= -(difference)) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Sushiswap`)
    console.log(`Sell\t -->\t Uniswap\n`)
    return [sRouter, uRouter]
  } else {
    return null
  }
}

const determineProfitability = async (_routerPath, _token0Contract, _token0, _token1) => {
  console.log(`Determining Profitability...\n`)

  let exchangeToBuy, exchangeToSell

  if (await _routerPath[0].getAddress() === await uRouter.getAddress()) {
    exchangeToBuy = "Uniswap"
    exchangeToSell = "Sushiswap"
  } else {
    exchangeToBuy = "Sushiswap"
    exchangeToSell = "Uniswap"
  }

  const uReserves = await getReserves(uPair)
  const sReserves = await getReserves(sPair)

  let minAmount

  if (uReserves[0] > sReserves[0]) {
    minAmount = BigInt(sReserves[0]) / BigInt(2)
  } else {
    minAmount = BigInt(uReserves[0]) / BigInt(2)
  }

  try {
    const estimate = await _routerPath[0].getAmountsIn(minAmount, [_token0.address, _token1.address])
    const result = await _routerPath[1].getAmountsOut(estimate[1], [_token1.address, _token0.address])

    console.log(`Estimated amount of WETH needed to buy enough Shib on ${exchangeToBuy}\t\t| ${ethers.formatUnits(estimate[0], 'ether')}`)
    console.log(`Estimated amount of WETH returned after swapping SHIB on ${exchangeToSell}\t| ${ethers.formatUnits(result[1], 'ether')}\n`)

    const { amountIn, amountOut } = await simulate(estimate[0], _routerPath, _token0, _token1)
    const amountDifference = amountOut - amountIn
    const estimatedGasCost = gasLimit * gasPrice

    const account = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

    const ethBalanceBefore = ethers.formatUnits(await provider.getBalance(account.address), 'ether')
    const ethBalanceAfter = ethBalanceBefore - estimatedGasCost

    const wethBalanceBefore = Number(ethers.formatUnits(await _token0Contract.balanceOf(account.address), 'ether'))
    const wethBalanceAfter = amountDifference + wethBalanceBefore
    const wethBalanceDifference = wethBalanceAfter - wethBalanceBefore

    const data = {
      'ETH Balance Before': ethBalanceBefore,
      'ETH Balance After': ethBalanceAfter,
      'ETH Spent (gas)': estimatedGasCost,
      '-': {},
      'WETH Balance BEFORE': wethBalanceBefore,
      'WETH Balance AFTER': wethBalanceAfter,
      'WETH Gained/Lost': wethBalanceDifference,
      '-': {},
      'Total Gained/Lost': wethBalanceDifference - estimatedGasCost
    }

    console.table(data)
    console.log()

    if (Number(amountOut) < Number(amountIn)) {
      return false
    }

    amount = ethers.parseUnits(amountIn, 'ether')
    return true

  } catch (error) {
    console.log(error)
    console.log(`\nError occurred while trying to determine profitability...\n`)
    console.log(`This can typically happen because of liquidity issues, see README for more information.\n`)
    return false
  }
}

const executeTrade = async (_routerPath, _token0Contract, _token1Contract) => {
  console.log(`Attempting Arbitrage...\n`)

  let startOnUniswap

  if (await _routerPath[0].getAddress() == await uRouter.getAddress()) {
    startOnUniswap = true
  } else {
    startOnUniswap = false
  }

  const account = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

  const tokenBalanceBefore = await _token0Contract.balanceOf(account.address)
  const ethBalanceBefore = await provider.getBalance(account.address)

  if (config.PROJECT_SETTINGS.isDeployed) {
    const transaction = await arbitrage.connect(account).executeTrade(
      startOnUniswap,
      await _token0Contract.getAddress(),
      await _token1Contract.getAddress(),
      amount,
      { gasLimit: process.env.GAS_LIMIT }
    )

    const receipt = await transaction.wait()
  }

  console.log(`Trade Complete:\n`)

  const tokenBalanceAfter = await _token0Contract.balanceOf(account.address)
  const ethBalanceAfter = await provider.getBalance(account.address)

  const tokenBalanceDifference = tokenBalanceAfter - tokenBalanceBefore
  const ethBalanceDifference = ethBalanceBefore - ethBalanceAfter

  const data = {
    'ETH Balance Before': ethers.formatUnits(ethBalanceBefore, 'ether'),
    'ETH Balance After': ethers.formatUnits(ethBalanceAfter, 'ether'),
    'ETH Spent (gas)': ethers.formatUnits(ethBalanceDifference.toString(), 'ether'),
    '-': {},
    'WETH Balance BEFORE': ethers.formatUnits(tokenBalanceBefore, 'ether'),
    'WETH Balance AFTER': ethers.formatUnits(tokenBalanceAfter, 'ether'),
    'WETH Gained/Lost': ethers.formatUnits(tokenBalanceDifference.toString(), 'ether'),
    '-': {},
    'Total Gained/Lost': `${ethers.formatUnits((tokenBalanceDifference - ethBalanceDifference).toString(), 'ether')} ETH`
  }

  console.table(data)
}

main().catch(console.error)
EOF

cat << 'EOF' > bot.js
const ethers = require("ethers")
const config = require('./config.json')
const { getTokenAndContract, getPairContract, getReserves, calculatePrice, simulate } = require('./helpers/helpers')
const { provider, uFactory, uRouter, sFactory, sRouter, arbitrage } = require('./helpers/initialization')

const arbFor = process.env.ARB_FOR
const arbAgainst = process.env.ARB_AGAINST
const units = process.env.UNITS
const difference = process.env.PRICE_DIFFERENCE
const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

let uPair, sPair, amount
let isExecuting = false

const main = async () => {
  const { token0Contract, token1Contract, token0, token1 } = await getTokenAndContract(arbFor, arbAgainst, provider)
  uPair = await getPairContract(uFactory, token0.address, token1.address, provider)
  sPair = await getPairContract(sFactory, token0.address, token1.address, provider)

  console.log(`uPair Address: ${await uPair.getAddress()}`)
  console.log(`sPair Address: ${await sPair.getAddress()}\n`)

  uPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Uniswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  sPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Sushiswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  console.log("Waiting for swap event...")
}

const checkPrice = async (_exchange, _token0, _token1) => {
  isExecuting = true

  console.log(`Swap Initiated on ${_exchange}, Checking Price...\n`)

  const currentBlock = await provider.getBlockNumber()

  const uPrice = await calculatePrice(uPair)
  const sPrice = await calculatePrice(sPair)

  const uFPrice = Number(uPrice).toFixed(units)
  const sFPrice = Number(sPrice).toFixed(units)
  const priceDifference = (((uFPrice - sFPrice) / sFPrice) * 100).toFixed(2)

  console.log(`Current Block: ${currentBlock}`)
  console.log(`-----------------------------------------`)
  console.log(`UNISWAP   | ${_token1.symbol}/${_token0.symbol}\t | ${uFPrice}`)
  console.log(`SUSHISWAP | ${_token1.symbol}/${_token0.symbol}\t | ${sFPrice}\n`)
  console.log(`Percentage Difference: ${priceDifference}%\n`)

  return priceDifference
}

const determineDirection = async (_priceDifference) => {
  console.log(`Determining Direction...\n`)

  if (_priceDifference >= difference) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Uniswap`)
    console.log(`Sell\t -->\t Sushiswap\n`)
    return [uRouter, sRouter]
  } else if (_priceDifference <= -(difference)) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Sushiswap`)
    console.log(`Sell\t -->\t Uniswap\n`)
    return [sRouter, uRouter]
  } else {
    return null
  }
}

const determineProfitability = async (_routerPath, _token0Contract, _token0, _token1) => {
  console.log(`Determining Profitability...\n`)

  let exchangeToBuy, exchangeToSell

  if (await _routerPath[0].getAddress() === await uRouter.getAddress()) {
    exchangeToBuy = "Uniswap"
    exchangeToSell = "Sushiswap"
  } else {
    exchangeToBuy = "Sushiswap"
    exchangeToSell = "Uniswap"
  }

  const uReserves = await getReserves(uPair)
  const sReserves = await getReserves(sPair)

  let minAmount

  if (uReserves[0] > sReserves[0]) {
    minAmount = BigInt(sReserves[0]) / BigInt(2)
  } else {
    minAmount = BigInt(uReserves[0]) / BigInt(2)
  }

  try {
    const estimate = await _routerPath[0].getAmountsIn(minAmount, [_token0.address, _token1.address])
    const result = await _routerPath[1].getAmountsOut(estimate[1], [_token1.address, _token0.address])

    console.log(`Estimated amount of WETH needed to buy enough Shib on ${exchangeToBuy}\t\t| ${ethers.formatUnits(estimate[0], 'ether')}`)
    console.log(`Estimated amount of WETH returned after swapping SHIB on ${exchangeToSell}\t| ${ethers.formatUnits(result[1], 'ether')}\n`)

    const { amountIn, amountOut } = await simulate(estimate[0], _routerPath, _token0, _token1)
    const amountDifference = amountOut - amountIn
    const estimatedGasCost = gasLimit * gasPrice

    const account = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

    const ethBalanceBefore = ethers.formatUnits(await provider.getBalance(account.address), 'ether')
    const ethBalanceAfter = ethBalanceBefore - estimatedGasCost

    const wethBalanceBefore = Number(ethers.formatUnits(await _token0Contract.balanceOf(account.address), 'ether'))
    const wethBalanceAfter = amountDifference + wethBalanceBefore
    const wethBalanceDifference = wethBalanceAfter - wethBalanceBefore

    const data = {
      'ETH Balance Before': ethBalanceBefore,
      'ETH Balance After': ethBalanceAfter,
      'ETH Spent (gas)': estimatedGasCost,
      '-': {},
      'WETH Balance BEFORE': wethBalanceBefore,
      'WETH Balance AFTER': wethBalanceAfter,
      'WETH Gained/Lost': wethBalanceDifference,
      '-': {},
      'Total Gained/Lost': wethBalanceDifference - estimatedGasCost
    }

    console.table(data)
    console.log()

    if (Number(amountOut) < Number(amountIn)) {
      return false
    }

    amount = ethers.parseUnits(amountIn, 'ether')
    return true

  } catch (error) {
    console.log(error)
    console.log(`\nError occurred while trying to determine profitability...\n`)
    console.log(`This can typically happen because of liquidity issues, see README for more information.\n`)
    return false
  }
}

const executeTrade = async (_routerPath, _token0Contract, _token1Contract) => {
  console.log(`Attempting Arbitrage...\n`)

  let startOnUniswap

  if (await _routerPath[0].getAddress() == await uRouter.getAddress()) {
    startOnUniswap = true
  } else {
    startOnUniswap = false
  }

  const account = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

  const tokenBalanceBefore = await _token0Contract.balanceOf(account.address)
  const ethBalanceBefore = await provider.getBalance(account.address)

  if (config.PROJECT_SETTINGS.isDeployed) {
    const transaction = await arbitrage.connect(account).executeTrade(
      startOnUniswap,
      await _token0Contract.getAddress(),
      await _token1Contract.getAddress(),
      amount,
      { gasLimit: process.env.GAS_LIMIT }
    )

    const receipt = await transaction.wait()
  }

  console.log(`Trade Complete:\n`)

  const tokenBalanceAfter = await _token0Contract.balanceOf(account.address)
  const ethBalanceAfter = await provider.getBalance(account.address)

  const tokenBalanceDifference = tokenBalanceAfter - tokenBalanceBefore
  const ethBalanceDifference = ethBalanceBefore - ethBalanceAfter

  const data = {
    'ETH Balance Before': ethers.formatUnits(ethBalanceBefore, 'ether'),
    'ETH Balance After': ethers.formatUnits(ethBalanceAfter, 'ether'),
    'ETH Spent (gas)': ethers.formatUnits(ethBalanceDifference.toString(), 'ether'),
    '-': {},
    'WETH Balance BEFORE': ethers.formatUnits(tokenBalanceBefore, 'ether'),
    'WETH Balance AFTER': ethers.formatUnits(tokenBalanceAfter, 'ether'),
    'WETH Gained/Lost': ethers.formatUnits(tokenBalanceDifference.toString(), 'ether'),
    '-': {},
    'Total Gained/Lost': `${ethers.formatUnits((tokenBalanceDifference - ethBalanceDifference).toString(), 'ether')} ETH`
  }

  console.table(data)
}

main().catch(console.error)
EOF

cat << 'EOF' > bot.js
const ethers = require("ethers")
const config = require('./config.json')
const { getTokenAndContract, getPairContract, getReserves, calculatePrice, simulate } = require('./helpers/helpers')
const { provider, uFactory, uRouter, sFactory, sRouter, arbitrage } = require('./helpers/initialization')

const arbFor = process.env.ARB_FOR
const arbAgainst = process.env.ARB_AGAINST
const units = process.env.UNITS
const difference = process.env.PRICE_DIFFERENCE
const gasLimit = process.env.GAS_LIMIT
const gasPrice = process.env.GAS_PRICE

let uPair, sPair, amount
let isExecuting = false

const main = async () => {
  const { token0Contract, token1Contract, token0, token1 } = await getTokenAndContract(arbFor, arbAgainst, provider)
  uPair = await getPairContract(uFactory, token0.address, token1.address, provider)
  sPair = await getPairContract(sFactory, token0.address, token1.address, provider)

  console.log(`uPair Address: ${await uPair.getAddress()}`)
  console.log(`sPair Address: ${await sPair.getAddress()}\n`)

  uPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Uniswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  sPair.on('Swap', async () => {
    if (!isExecuting) {
      isExecuting = true

      const priceDifference = await checkPrice('Sushiswap', token0, token1)
      const routerPath = await determineDirection(priceDifference)

      if (!routerPath) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const isProfitable = await determineProfitability(routerPath, token0Contract, token0, token1)

      if (!isProfitable) {
        console.log(`No Arbitrage Currently Available\n`)
        console.log(`-----------------------------------------\n`)
        isExecuting = false
        return
      }

      const receipt = await executeTrade(routerPath, token0Contract, token1Contract)

      isExecuting = false
    }
  })

  console.log("Waiting for swap event...")
}

const checkPrice = async (_exchange, _token0, _token1) => {
  isExecuting = true

  console.log(`Swap Initiated on ${_exchange}, Checking Price...\n`)

  const currentBlock = await provider.getBlockNumber()

  const uPrice = await calculatePrice(uPair)
  const sPrice = await calculatePrice(sPair)

  const uFPrice = Number(uPrice).toFixed(units)
  const sFPrice = Number(sPrice).toFixed(units)
  const priceDifference = (((uFPrice - sFPrice) / sFPrice) * 100).toFixed(2)

  console.log(`Current Block: ${currentBlock}`)
  console.log(`-----------------------------------------`)
  console.log(`UNISWAP   | ${_token1.symbol}/${_token0.symbol}\t | ${uFPrice}`)
  console.log(`SUSHISWAP | ${_token1.symbol}/${_token0.symbol}\t | ${sFPrice}\n`)
  console.log(`Percentage Difference: ${priceDifference}%\n`)

  return priceDifference
}

const determineDirection = async (_priceDifference) => {
  console.log(`Determining Direction...\n`)

  if (_priceDifference >= difference) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Uniswap`)
    console.log(`Sell\t -->\t Sushiswap\n`)
    return [uRouter, sRouter]
  } else if (_priceDifference <= -(difference)) {
    console.log(`Potential Arbitrage Direction:\n`)
    console.log(`Buy\t -->\t Sushiswap`)
    console.log(`Sell\t -->\t Uniswap\n`)
    return [sRouter, uRouter]
  } else {
    return null
  }
}

const determineProfitability = async (_routerPath, _token0Contract, _token0, _token1) => {
  console.log(`Determining Profitability...\n`)

  let exchangeToBuy, exchangeToSell

  if (await _routerPath[0].getAddress() === await uRouter.getAddress()) {
    exchangeToBuy = "Uniswap"
    exchangeToSell = "Sushiswap"
  } else {
    exchangeToBuy = "Sushiswap"
    exchangeToSell = "Uniswap"
  }

  const uReserves = await getReserves(uPair)
  const sReserves = await getReserves(sPair)

  let minAmount

  if (uReserves[0] > sReserves[0]) {
    minAmount = BigInt(sReserves[0]) / BigInt(2)
  } else {
    minAmount = BigInt(uReserves[0]) / BigInt(2)
  }

  try {
    const estimate = await _routerPath[0].getAmountsIn(minAmount, [_token0.address, _token1.address])
    const result = await _routerPath[1].getAmountsOut(estimate[1], [_token1.address, _token0.address])

    console.log(`Estimated amount of WETH needed to buy enough Shib on ${exchangeToBuy}\t\t| ${ethers.formatUnits(estimate[0], 'ether')}`)
    console.log(`Estimated amount of WETH returned after swapping SHIB on ${exchangeToSell}\t| ${ethers.formatUnits(result[1], 'ether')}\n`)

    const { amountIn, amountOut } = await simulate(estimate[0], _routerPath, _token0, _token1)
    const amountDifference = amountOut - amountIn
    const estimatedGasCost = gasLimit * gasPrice

    const account = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

    const ethBalanceBefore = ethers.formatUnits(await provider.getBalance(account.address), 'ether')
    const ethBalanceAfter = ethBalanceBefore - estimatedGasCost

    const wethBalanceBefore = Number(ethers.formatUnits(await _token0Contract.balanceOf(account.address), 'ether'))
    const wethBalanceAfter = amountDifference + wethBalanceBefore
    const wethBalanceDifference = wethBalanceAfter - wethBalanceBefore

    const data = {
      'ETH Balance Before': ethBalanceBefore,
      'ETH Balance After': ethBalanceAfter,
      'ETH Spent (gas)': estimatedGasCost,
      '-': {},
      'WETH Balance BEFORE': wethBalanceBefore,
      'WETH Balance AFTER': wethBalanceAfter,
      'WETH Gained/Lost': wethBalanceDifference,
      '-': {},
      'Total Gained/Lost': wethBalanceDifference - estimatedGasCost
    }

    console.table(data)
    console.log()

    if (Number(amountOut) < Number(amountIn)) {
      return false
    }

    amount = ethers.parseUnits(amountIn, 'ether')
    return true

  } catch (error) {
    console.log(error)
    console.log(`\nError occurred while trying to determine profitability...\n`)
    console.log(`This can typically happen because of liquidity issues, see README for more information.\n`)
    return false
  }
}

const executeTrade = async (_routerPath, _token0Contract, _token1Contract) => {
  console.log(`Attempting Arbitrage...\n`)

  let startOnUniswap

  if (await _routerPath[0].getAddress() == await uRouter.getAddress()) {
    startOnUniswap = true
  } else {
    startOnUniswap = false
  }

  const account = new ethers.Wallet(process.env.PRIVATE_KEY, provider)

  const tokenBalanceBefore = await _token0Contract.balanceOf(account.address)
  const ethBalanceBefore = await provider.getBalance(account.address)

  if (config.PROJECT_SETTINGS.isDeployed) {
    const transaction = await arbitrage.connect(account).executeTrade(
      startOnUniswap,
      await _token0Contract.getAddress(),
      await _token1Contract.getAddress(),
      amount,
      { gasLimit: process.env.GAS_LIMIT }
    )

    const receipt = await transaction.wait()
  }

  console.log(`Trade Complete:\n`)

  const tokenBalanceAfter = await _token0Contract.balanceOf(account.address)
  const ethBalanceAfter = await provider.getBalance(account.address)

  const tokenBalanceDifference = tokenBalanceAfter - tokenBalanceBefore
  const ethBalanceDifference = ethBalanceBefore - ethBalanceAfter

  const data = {
    'ETH Balance Before': ethers.formatUnits(ethBalanceBefore, 'ether'),
    'ETH Balance After': ethers.formatUnits(ethBalanceAfter, 'ether'),
    'ETH Spent (gas)': ethers.formatUnits(ethBalanceDifference.toString(), 'ether'),
    '-': {},
    'WETH Balance BEFORE': ethers.formatUnits(tokenBalanceBefore, 'ether'),
    'WETH Balance AFTER': ethers.formatUnits(tokenBalanceAfter, 'ether'),
    'WETH Gained/Lost': ethers.formatUnits(tokenBalanceDifference.toString(), 'ether'),
    '-': {},
    'Total Gained/Lost': `${ethers.formatUnits((tokenBalanceDifference - ethBalanceDifference).toString(), 'ether')} ETH`
  }

  console.table(data)
}

main().catch(console.err
# Remove existing project
cd ~
rm -rf ethereum-arb-bot
mkdir ethereum-arb-bot
cd ethereum-arb-bot

# Install essential tools
npm init -y
npm install ethers hardhat @uniswap/v2-periphery @balancer-labs/v2-vault dotenv big.js
npx hardhat
# SSH into your Linode server
ssh root@your_server_ip

# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl git build-essential
# Install Node Version Manager (NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Reload shell
source ~/.bashrc

# Install latest LTS Node.js
nvm install --lts
nvm use --lts
# Create project directory
mkdir -p ~/ethereum-arbitrage-bot
cd ~/ethereum-arbitrage-bot

# Initialize Node.js project
npm init -y

# Install core dependencies
npm install ethers hardhat @uniswap/v2-periphery @balancer-labs/v2-vault dotenv big.js
# Initialize Hardhat project
npx hardhat

# Select "Create an empty hardhat.config.js"
# When prompted, choose JavaScript

# Edit hardhat configuration
nano hardhat.config.js
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.19",
  networks: {
    mainnet: {
      url: `https://eth-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
# Create .env file
nano .env
ALCHEMY_API_KEY=your_alchemy_api_key
PRIVATE_KEY=your_ethereum_wallet_private_key
ARB_TOKEN=0xToken_Address_to_Arbitrage
PRICE_DIFFERENCE_THRESHOLD=0.5
MAX_GAS_PRICE=50
chmod 600 .env
npm install \
  @uniswap/v2-core \
  @balancer-labs/v2-vault \
  @openzeppelin/contracts \
  big.js \
  ws \
  axios

