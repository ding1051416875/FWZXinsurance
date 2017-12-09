cordova.define("cordova-plugin-share.www.Share",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            share: function(successCallback, errorCallback, content){
                exec(
                successCallback,
                errorCallback,
                "Share",//feature name
                "share",//action
                [content]//要传递的参数，json格式
                );
            }
        }
});