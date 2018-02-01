cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
        {
                    "file": "plugins/cordova-plugin-signature.www/signature.js",//js文件路径
                    "id": "cordova-plugin-signature.www.Signature",//js cordova.define的id
                    "clobbers": [
                        "Signature"//js 调用时的方法名
                    ]
                },
          {
                 "file": "plugins/cordova-plugin-email.www/email.js",//js文件路径
                 "id": "cordova-plugin-email.www.Email",//js cordova.define的id
                 "clobbers": [
                      "Email"//js 调用时的方法名
                 ]
          },
           {
            "file": "plugins/cordova-plugin-qcode.www/qcode.js",//js文件路径
             "id": "cordova-plugin-qcode.www.QCode",//js cordova.define的id
              "clobbers": [
                   "QCode"//js 调用时的方法名
                 ]
                    },
              {
                "file": "plugins/cordova-plugin-baiduocr.www/baidu_ocr.js",//js文件路径
                 "id": "cordova-plugin-baiduocr.www.FULAN_OCR",//js cordova.define的id
                 "clobbers": [
                     "FULAN_OCR"//js 调用时的方法名
                  ]
                   },
               {
                  "file": "plugins/cordova-plugin-ifly.www/ifly.js",//js文件路径
                  "id": "cordova-plugin-ifly.www.FULAN_IFLY",//js cordova.define的id
                  "clobbers": [
                  "FULAN_IFLY"//js 调用时的方法名
                    ]
                   },
              {
              "file": "plugins/cordova-plugin-share.www/share.js",//js文件路径
              "id": "cordova-plugin-share.www.Share",//js cordova.define的id
              "clobbers": [
                "Share"//js 调用时的方法名
                 ]
               },
             {
               "file": "plugins/cordova-plugin-pen.www/pen.js",//js文件路径
                "id": "cordova-plugin-pen.www.Pen",//js cordova.define的id
                "clobbers": [
                "Pen"//js 调用时的方法名
                  ]
                  },
                  {
                  "file": "plugins/cordova-plugin-pdf.www/pdf.js",//js文件路径
                  "id": "cordova-plugin-pdf.www.Pdf",//js cordova.define的id
                  "clobbers": [
                               "PDF"//js 调用时的方法名
                               ]
                  }
                  ,
                  {
                  "file": "plugins/cordova-plugin-ppt.www/ppt.js",//js文件路径
                  "id": "cordova-plugin-ppt.www.Ppt",//js cordova.define的id
                  "clobbers": [
                               "PPT"//js 调用时的方法名
                               ]
                  }
                  ,
                  {
                  "file": "plugins/cordova-plugin-add.www/add.js",//js文件路径
                  "id": "cordova-plugin-add.www.Add",//js cordova.define的id
                  "clobbers": [
                               "Add"//js 调用时的方法名
                               ]
                  }
                  ,
                  {
                  "file": "plugins/cordova-plugin-occupation.www/occupation.js",//js文件路径
                  "id": "cordova-plugin-occupation.www.Occupation",//js cordova.define的id
                  "clobbers": [
                               "Occupation"//js 调用时的方法名
                               ]
                  }
                  ,
                  {
                  "file": "plugins/cordova-plugin-upcardid.www/upcardid.js",//js文件路径
                  "id": "cordova-plugin-upcardid.www.UpCardId",//js cordova.define的id
                  "clobbers": [
                               "UpCardId"//js 调用时的方法名
                               ]
                  }
                  

                 

                 
                 
 
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.3",
  "cordova-plugin-camera": "3.0.0",
  "cordova-plugin-device": "1.1.6",
  "cordova-plugin-geolocation": "3.0.0"
};
// BOTTOM OF METADATA
});
