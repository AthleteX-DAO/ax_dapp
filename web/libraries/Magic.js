var MagicSDK = (function () {
    function MagicSDK(apiKey, chainId, rpcUrl, locale, extension) {
        this._magicSDK = new Magic('pk_live_A0EFC48FF2C1D624', {
            // network: {
            //     chainId, chainId,
            //     rpcUrl: rpcUrl,
            // },
            network: "goerli",
            locale: "en_US",
            extensions: [new MagicConnectExtension()],
        });
        this._web3 = new Web3(this._magicSDK.rpcProvider);
        console.log(Web3);
        console.log(this._magicSDK);
        console.log(this._magicSDK.rpcProvider);
    }

    MagicSDK.prototype.connect = async function () {
        console.log("Connecting to Magic");      
        console.log(this._web3);
        const address = (await this._web3.eth.getAccounts())[0];
        console.log("This is the address " + address);
        console.log(typeof address);
        return address;
    }

    MagicSDK.prototype.showWallet = async function () {
        await this._magicSDK.connect.showWallet();
        // extension.showWallet();
        // const token = await this._magicSDK.webauthn.registerNewUser({ username: 'michael' });
        // await this._magicSDK.connect.showWallet();
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

    return MagicSDK;
})();