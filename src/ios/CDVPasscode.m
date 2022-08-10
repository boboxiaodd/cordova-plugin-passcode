#import <Cordova/CDV.h>
#import "CDVPasscode.h"
#import "LTHPasscodeViewController.h"

@interface CDVPasscode () <LTHPasscodeViewControllerDelegate>
@property (nonatomic,strong) CDVInvokedUrlCommand * passcode_command;
@end

@implementation CDVPasscode


-(void)pluginInitialize
{
    [LTHPasscodeViewController sharedUser].delegate = self;
    [[LTHPasscodeViewController sharedUser] setMaxNumberOfAllowedFailedAttempts:5];
}

-(void)init_passcode:(CDVInvokedUrlCommand *)command
{
    if([[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    _passcode_command = command;
    if([[LTHPasscodeViewController sharedUser] passCodeExists]){
        [[LTHPasscodeViewController sharedUser] deletePasscode];
    }
    [LTHPasscodeViewController sharedUser].enablePasscodeString = @"初始化密码";
    [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self.viewController asModal:YES];
}
-(void)show_passcode:(CDVInvokedUrlCommand *)command
{
    if([[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    if([[LTHPasscodeViewController sharedUser] passCodeExists]){
        _passcode_command = command;
        [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self.viewController asModal:YES];
    }
}
-(void)change_passcode:(CDVInvokedUrlCommand *)command
{
    if([[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    if([[LTHPasscodeViewController sharedUser] passCodeExists]){
        _passcode_command = command;
        [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self.viewController asModal:YES];
    }
}
-(void)del_passcode:(CDVInvokedUrlCommand *)command
{
    if([[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    if([[LTHPasscodeViewController sharedUser] passCodeExists]){
        _passcode_command = command;
        [[LTHPasscodeViewController sharedUser] deletePasscode];
    }
}
-(void)close:(CDVInvokedUrlCommand *)command
{
    if(![[LTHPasscodeViewController sharedUser] isCurrentlyOnScreen]) return;
    [[LTHPasscodeViewController sharedUser] closeModal];
}

#pragma mark LTHPasscodeViewControllerDelegate
- (void)passcodeViewControllerWillClose {
    if(_passcode_command){
        [self send_event:_passcode_command withMessage:@{@"event":@"close"} Alive:NO State:YES];
    }
}
- (BOOL)allowUnlockWithBiometrics{
    return NO;
}
- (void)maxNumberOfFailedAttemptsReached{
    if(_passcode_command){
        [self send_event:_passcode_command withMessage:@{@"event":@"fail"} Alive:NO State:YES];
    }
}

#pragma mark 公共方法

- (void)send_event:(CDVInvokedUrlCommand *)command withMessage:(NSDictionary *)message Alive:(BOOL)alive State:(BOOL)state{
    if(!command) return;
    CDVPluginResult* res = [CDVPluginResult resultWithStatus: (state ? CDVCommandStatus_OK : CDVCommandStatus_ERROR) messageAsDictionary:message];
    if(alive) [res setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult: res callbackId: command.callbackId];
}
@end
