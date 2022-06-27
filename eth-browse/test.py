import config
from web3 import Web3

w3 = Web3(Web3.HTTPProvider(config.ALCHEMY_URL))
print('here', w3.eth.block_number)
