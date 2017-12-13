cordova.define("cordova-plugin-upcardid.www.UpCardId",
               function(require, exports, module) {
               var exec = require("cordova/exec");
               module.exports = {
               upCardId: function(successCallback, errorCallback,customer,policy,seqNum,type,customerType,url){
               exec(
                    successCallback,
                    errorCallback,
                    "UpCardId",//feature name
                    "upCardId",//action
                    [customer,policy,seqNum,type,customerType,url]//要传递的参数，json格式
                    );
               }
               }
               });
