var MagicSDK = (function () {
    function MagicSDK(apiKey) {
        this._magicSDK = new Magic('pk_live_A0EFC48FF2C1D624');
        this._web3 = new Web3(this._magicSDK.rpcProvider);
        
        /// Places the magic ethereum client onto the window object
        window.magicEthereum = this._web3.eth;
        console.log(Web3);
    }

    MagicSDK.prototype.connect = async function () {
        console.log("Connecting to Magic");      
        const address = (await this._web3.eth.getAccounts())[0];
        console.log(this._web3);
        console.log("This is the address " + address);
        console.log(typeof address);
        return address;
    }

    MagicSDK.prototype.showWallet = async function () {
        await this._magicSDK.connect.showWallet();
    }

    MagicSDK.prototype.disconnect = async function () {
        console.log("disconnect");
        await this._magicSDK.connect.disconnect();
    }

    MagicSDK.prototype.getWalletInfo = async function () {
        console.log("get wallet info");
        const walletInfo = await this._magicSDK.connect.getWalletInfo();
        console.log(walletInfo);
        return walletInfo;
    }

    MagicSDK.prototype.requestUserInfo = async function () {
        console.log("request user information");
        const email = await this._magicSDK.connect.requestUserInfo();
        return email;
    }

    Magic.prototype.requestAccount = async function () {
        console.log("Requesting User Credentials");
        const credentials = await this._web3.eth.requestAccount();
        return credentials;
    }
q
    return MagicSDK;
})();