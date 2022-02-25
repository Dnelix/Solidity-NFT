// require the chaiJS library. Chai is an assertion library used for running JS tests with three main functions: Should. Expect & Assert.
const {assert} = require('chai')

// assign the path to the JSON file in the abis
const KryptoBird = artifacts.require('./Kryptobird')

// check for chai
require('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird', (accounts) => {
    let contract // get the contract into a global variable
    
    //before function ensures this is run first
    before( async () => {
        contract = await KryptoBird.deployed()
    })

    //testing container
    describe('deployment', async() => {
        //test samples using "it"
        it('deploys successfully', async() => {
            const address = contract.address;
            assert.notEqual(address, '') // using the assert function of Chai to test that address cannot be empty
            assert.notEqual(address, null) // using the assert function of Chai to test that address cannot be empty
            assert.notEqual(address, undefined) // using the assert function of Chai to test that address cannot be empty
            assert.notEqual(address, 0x0) // using the assert function of Chai to test that address cannot be empty
        })
        it('has a name', async() => {
            const name = await contract.name()
            assert.equal(name, 'Kryptobirdy')
        })
        it('has a symnbol', async() => {
            const name = await contract.symbol()
            assert.equal(name, 'KRBD')
        })
    })

    describe('minting', async ()=> {
        it('creates a new token', async ()=> {
            const result = await contract.mint('Felix')
            const totalSupply = await contract.totalSupply()

            // test for success
            assert.notEqual(totalSupply, '') //total supply cannot be empty since we have minted above
            const event = result.logs[0].args
            assert.equal(event._from, '0x0000000000000000000000000000000000000000') // the sender is the zero address
            assert.equal(event._to, accounts[0], 'to is msg.sender')

            // failure
            await contract.mint('Felix').should.be.rejected
        })
    })

    describe('indexing', async ()=> {
        it('List of items', async() => {
            //mint three new tokens
            await contract.mint('Chijioke')
            await contract.mint('Pam')
            await contract.mint('12345')

            const totalSupply = await contract.totalSupply()

            // Loop through the list and grab minted items
            let result = []
            let KryptoBird
            for(i=0; i < totalSupply; i++){
                KryptoBird = await contract.Kryptobirdz(i) //recall the Kryptobirdz array was created in krptobirdz.sol to hold the NFTs
                result.push(KryptoBird)
            }
            // assert that new array matches expected result
            let expected = ['Felix','Chijioke','Pam','12345']
            assert.equal(result.join(','), expected.join(','))

        })
    })
})