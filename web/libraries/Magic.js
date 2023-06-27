var MagicSDK = (function () {
    function MagicSDK(apiKey) {

        const customNodeOptions = {
            rpcUrl: 'https://rpc.sx.technology/',
            chainId: 416
        }

        this._magicSDK = new Magic('pk_live_A0EFC48FF2C1D624', {
            network: customNodeOptions,
        });
        this._web3 = new Web3(this._magicSDK.rpcProvider); // Comment: the Web3 function exists in the DOM
        
        this._magicSDK.preload().then(() => console.log('Magic <iframe> loaded.'));
        /// Places the magic ethereum client onto the window object
        console.log(Web3);
    }

    MagicSDK.prototype.connect = async function () {
       const address = await (this._magicSDK.wallet.connectWithUI())[0];
       return address;
    }

    MagicSDK.prototype.disconnect = async function () {
        console.log("disconnect");
        await this._magicSDK.wallet.disconnect();
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

    MagicSDK.prototype.requestAccount = async function () {
        console.log("Requesting User Credentials");
        const credentials = await this._magicSDK.wallet.connectWithUI();
        return credentials;
    }

    MagicSDK.prototype.getGasPrice = async function () {
        console.log("[Magic] Requesting on-chain gas price...")
        const gasPriceInGwei = await this._web3.eth.getGasPrice();
        return gasPriceInGwei;
    }

    return MagicSDK;
})();