#import <Cordova/CDV.h>
#import "CDVPasscode.h"
#import "LTHPasscodeViewController.h"
#import "MBProgressHUD.h"

@interface CDVPasscode () <LTHPasscodeViewControllerDelegate>
@property (nonatomic,strong) CDVInvokedUrlCommand * passcode_command;
@end

@implementation CDVPasscode


-(void)pluginInitialize
{
    [LTHPasscodeViewController sharedUser].delegate = self;
}


-(void)show_passcode:(CDVInvokedUrlCommand *)command
{
    if([[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    _passcode_command = command;
    [LTHPasscodeViewController sharedUser].title = @"输入密码解锁";
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self.viewController asModal:YES];
}

-(void)close:(CDVInvokedUrlCommand *)command
{
    if(![[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    [[LTHPasscodeViewController sharedUser] closeModal];
}

#pragma mark LTHPasscodeViewControllerDelegate
- (BOOL)allowUnlockWithBiometrics{
    return NO;
}

- (void)logoutButtonWasPressed
{
    if(_passcode_command){
        [self send_event:_passcode_command withMessage:@{@"event":@"help"} Alive:YES State:YES];
    }
}
- (void)savePasscode:(NSString *)passcode
{
    [self showHint:@"请稍后..."];
    if(_passcode_command){
        [self send_event:_passcode_command withMessage:@{@"event":@"done",@"passcode":passcode} Alive:YES State:YES];
    }
}


#pragma mark 公共方法

- (void)send_event:(CDVInvokedUrlCommand *)command withMessage:(NSDictionary *)message Alive:(BOOL)alive State:(BOOL)state{
    if(!command) return;
    CDVPluginResult* res = [CDVPluginResult resultWithStatus: (state ? CDVCommandStatus_OK : CDVCommandStatus_ERROR) messageAsDictionary:message];
    if(alive) [res setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult: res callbackId: command.callbackId];
}

- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
}

@end
