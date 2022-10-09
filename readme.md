forge init frmandy

forge install 


forge install transmissions11/solmate Openzeppelin/openzeppelin-contracts


rollups/onchain/rollups/contracts/facets/ERC721PortalFacet.sol

onchain/rollups/contracts/facets/OutputFacet.sol

// goerli hardfork 

anvil --host 0.0.0.0 --chain-id 5 --hardfork latest --balance 10000000000000000 --accounts 1 --rpc-url $ALCHEMY_GOERLI_URL

export PRIVATE_KEYS=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

forge create NFT --rpc-url=http://0.0.0.0:8545 --private-key=$PRIVATE_KEYS --constructor-args frmandy_NFT FMA 
