cordova.define("cordova-plugin-baiduocr.www.FULAN_OCR",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            getIdInfo: function(successCallback, errorCallback){
                exec(
                successCallback,
                errorCallback,
                "FULAN_OCR",//feature name
                "getIdInfo",//action
                []//要传递的参数，json格式
                );
            }
        }
});
