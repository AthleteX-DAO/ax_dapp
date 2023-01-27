var MagicSDK = (function () {
    function MagicSDK(apiKey, chainId, rpcUrl, locale, extension) {
        this._magicSDK = new Magic('pk_live_064D386F90F4DF26', {
            // network: {
            //     chainId, chainId,
            //     rpcUrl: rpcUrl,
            // },
            network: "goerli",
            locale: "en_US",
            extensions: [new MagicConnectExtension()],
        });
        this._web3 = new Web3(this._magicSDK.rpcProvider);
    }

    MagicSDK.prototype.showWallet = async function () {
        await this._web3.eth.getAccounts();
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
        const walletInfo = await this_.MagicSDK.connect.getWalletInfo();
        console.log(walletInfo);
        return walletInfo;
    }

    MagicSDK.prototype.requestUserInfo = async function () {
        console.log("request user information");
        const email = await this._magicSDK.connect.requestUserInfo();
        return email;
    }

    MagicSDK.prototype.getIdToken = async function () {
        console.log("get id token");
        const idToken = await this._magicSDK.user.getIdToken();
        return idToken;
    }

    MagicSDK.prototype.getMetadata = async function () {
        console.log("metadata -> user information");
        const { issuer, email, phoneNumber, publicAddress } = await this._magicSDK.user.getMetadata();
        return { issuer, email, phoneNumber, publicAddress };
    }

    MagicSDK.prototype.isLoggedIn = async function () {
        console.log("is the user logged in to the app");
        const isLoggedIn = await this._magicSDK.user.isLoggedIn();
        return isLoggedIn;
    }

    MagicSDK.prototype.logOut = async function () {
        console.log("logging the user out");
        await this._magicSDK.user.logOut();
    }

    return MagicSDK;
})();