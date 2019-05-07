
var Token = artifacts.require('./Token.sol');

contract('Token', function (accounts) {
    var token;
    var totalSupply = 1000000;// 1mil
    it('Deploy token', () => {
        // Deploy new token contract
        return Token.new(totalSupply).then((instance) => {
            token = instance;
            console.log("=======Contract address is " + token.address);
        })
    })

    it('Should issues 20 tokens', () => {
        var ac = accounts[1];
        var amount = "20";
        var price = 100;
        var cost = amount/price +"";
        // Send 2000 wei to the token contract
        return token.sendTransaction({from: ac, value: web3.utils.toWei(cost)}).then((rs)=>{
            return token.balanceOf.call(ac).then((rs)=>{
                assert.equal(rs.toString(10) , amount,"Balance must be 20")
            })
        })
    });


});
