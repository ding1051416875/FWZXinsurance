cordova.define("cordova-plugin-upcardid.www.UpCardId",
               function(require, exports, module) {
               var exec = require("cordova/exec");
               module.exports = {
               UpCardId: function(successCallback, errorCallback){
               exec(
                    successCallback,
                    errorCallback,
                    "UpCardId",//feature name
                    "upCardId",//action
                    []//要传递的参数，json格式
                    );
               }
               }
               });
