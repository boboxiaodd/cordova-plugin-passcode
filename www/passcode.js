const exec = require('cordova/exec');
const CDVPasscode = {
    show_passcode:function (success,options){
        exec(success,null,'CDVPasscode','show_passcode',[options]);
    },
    close:function (){
        exec(null,null,'CDVPasscode','close',[]);
    }
};
module.exports = CDVPasscode;
