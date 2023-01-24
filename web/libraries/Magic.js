var Magic = (function () {
    function Magic(apiKey, chainId, rpcUrl, locale) {
        this._magic = new Magic({
            apiKey,
            network: {
                chainId, chainId,
                rpcUrl: rpcUrl,
            },
            locale: locale,
        });

        console.log("constructor", _this.magic);
    }

    Magic.prototype.showWallet = async function () {
        console.log("show wallet")
        await _this.magic.connect.showWallet();
    }

    Magic.prototype.disconnect = async function () {
        console.log("disconnect");
        await _this.magic.connect.disconnect();
    }

    Magic.prototype.getWalletInfo = async function () {
        console.log("get wallet info");
        const walletInfo = await _this.magic.connect.getWalletInfo();
        console.log(walletInfo);
        return walletInfo;
    }

    Magic.prototype.requestUserInfo = async function () {
        console.log("request user information");
        const email = await _this.magic.connect.requestUserInfo();
        return email;
    }

    Magic.prototype.getIdToken = async function () {
        console.log("get id token");
        const idToken = await _this.magic.user.getIdToken();
        return idToken;
    }

    Magic.prototype.getMetadata = async function () {
        console.log("metadata -> user information");
        const { issuer, email, phoneNumber, publicAddress } = await _this.magic.user.getMetadata();
        return { issuer, email, phoneNumber, publicAddress };
    }

    Magic.prototype.isLoggedIn = async function () {
        console.log("is the user logged in to the app");
        const isLoggedIn = await _this.magic.user.isLoggedIn();
        return isLoggedIn;
    }

    Magic.prototype.logOut = async function () {
        console.log("logging the user out");
        await _this.magic.user.logOut();
    }

    return Magic;
})();