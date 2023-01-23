var Magic = (function() {
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

    Magic.prototype.showWallet = async function() {
        console.log("show wallet")
        await _this.magic.connect.showWallet();
    }

    Magic.prototype.disconnect = async function() {
        console.log("disconnect");
        await _this.magic.connect.disconnect();
    }

    Magic.prototype.getWalletInfo = async function() {
        console.log("get wallet info");
        const walletInfo = await _this.magic.connect.getWalletInfo();
        console.log(walletInfo);
        return walletInfo;
    }

    return Magic;
})();