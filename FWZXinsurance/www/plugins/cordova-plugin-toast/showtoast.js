cordova.define("cordova-plugin-toast.ShowToast",
    function(require, exports, module) {
        var exec = require("cordova/exec");
        module.exports = {
            show: function(successCallback, errorCallback){
                exec(
                successCallback,
                errorCallback,
                "ShowToast",//feature name
                "show",//action
                ""//要传递的参数，json格式
                );
            }
        }
});