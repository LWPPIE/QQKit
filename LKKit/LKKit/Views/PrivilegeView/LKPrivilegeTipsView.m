//
//  LKPrivilegeTipsView.m
//  Live
//
//  Created by iOS on 16/4/5.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "LKPrivilegeTipsView.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "LKMacros.h"
#import "LSYConstance.h"
#import <YYKit/UIView+YYAdd.h>
#import <YYKit/UIColor+YYAdd.h>

@interface LKPrivilegeTipsView () <CLLocationManagerDelegate,UIAlertViewDelegate>
@property (strong,nonatomic) UIImageView * cameraImageView;
@property (strong,nonatomic) UIImageView * micImageView;
@property (strong,nonatomic) UIImageView * positionImageView;
@property (strong,nonatomic) UIButton * cameraBtn;
@property (strong,nonatomic) UIButton * micBtn;
@property (strong,nonatomic) UIButton * positionBtn;
@property (assign,nonatomic) int rootNum;
@property (assign,nonatomic) int liveNum;
@end

@implementation LKPrivilegeTipsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setupPrivileges:(NSArray *)privileges
{
    [self setupUIButtons:privileges];
}

- (void)setupUIButtons:(NSArray *)privileges
{
    UIView * rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 250)];
    rootView.center = CGPointMake(kDeviceWidth/2,kDeviceHeight/2);
    rootView.backgroundColor = UIColorHexAndAlpha(0xffffff, 0.9);
    rootView.layer.masksToBounds = YES;
    rootView.layer.cornerRadius = 10.0;
    [self addSubview:rootView];
    
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"live_icon_close"] forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"live_icon_close_h"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(240 -40, 0, 44, 44);
    [rootView addSubview:closeBtn];
    
    UILabel * titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 240, 30)];
    titileLabel.text = LKLocalizedString(@"上传视频需允许以下权限");
    titileLabel.textAlignment = NSTextAlignmentCenter;
    titileLabel.font = [UIFont systemFontOfSize:14];
    titileLabel.textColor = UIColorHexAndAlpha(0x333333, 0.9);
    [rootView addSubview:titileLabel];
    
    NSArray * arr = [NSArray arrayWithObjects:LKLocalizedString(@"相册权限"), LKLocalizedString(@"相机权限"),LKLocalizedString(@"麦克风权限"), nil];
    
    for (int i = 0; i < privileges.count; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(30, 75+55*i, 180, 45);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 45.0/2.0;
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0,55, 0, 0);
        btn.backgroundColor = UIColorHexAndAlpha(0xd6dbdb, 0.9);
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHex(0xffffff) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorHexAndAlpha(0x000000, 1.0) forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rootView addSubview:btn];
        btn.tag = 101+i;
        
        UIImageView * btnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 11, 23, 23)];
        btnImageView.image = [UIImage imageNamed:@"home_root_selected"];
        if(i == 0)
        {
            self.cameraImageView = btnImageView;
            self.cameraBtn = btn;

            if(privileges.count != 0 ){
                if([[privileges objectAtIndex:i] intValue] == 1){
                    [self changeButtom: self.cameraBtn and:self.cameraImageView];
                }
            }
        }
        else if (i == 1)
        {
            self.micImageView = btnImageView;
            self.micBtn = btn;
            if(privileges.count > 1 ){
                if([[privileges objectAtIndex:i] intValue] == 1){
                    [self changeButtom: self.micBtn and:self.micImageView];
                }
            }
        }
        else if(i == 2)
        {
            self.positionImageView = btnImageView;
            self.positionBtn = btn;
            
            if(privileges.count > 2 ){
                if([[privileges objectAtIndex:i] intValue] == 1){
                    [self changeButtom: self.positionBtn and:self.positionImageView];
                }
            }
        }
        
        [btn addSubview:btnImageView];
    }
}

- (IBAction)clickCloseButton:(id)sender
{
    if (_closePrivilegeView) {
        _closePrivilegeView();
    }
}

- (IBAction)clickButton:(id)sender
{
    UIButton * btn = sender;
    switch (btn.tag) {
        case 101:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LKLocalizedString(@"温馨提示") message:LKLocalizedString(@"点击(去设置)，找到(照片)开启即可") delegate:self cancelButtonTitle:LKLocalizedString(@"取消") otherButtonTitles:LKLocalizedString(@"去设置"), nil];
            [alert show];
        }
            break;
        case 102:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LKLocalizedString(@"温馨提示") message:LKLocalizedString(@"点击(去设置)，找到(相机)开启即可") delegate:self cancelButtonTitle:LKLocalizedString(@"取消") otherButtonTitles:LKLocalizedString(@"去设置"), nil];
            [alert show];
        }
            break;
        case 103:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LKLocalizedString(@"温馨提示") message:LKLocalizedString(@"点击(去设置)，找到(麦克风)开启即可") delegate:self cancelButtonTitle:LKLocalizedString(@"取消") otherButtonTitles:LKLocalizedString(@"去设置"), nil];
            [alert show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1) {
        
        if (IOS10) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }else {
            NSURL *url = [NSURL URLWithString:@"prefs:root=com.laka.novelty"];
            if ([[UIApplication sharedApplication] canOpenURL:url]){
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}

-  (void)changeButtom:(UIButton *) btn and:(UIImageView *) imageview
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIColor * myHexColor;
        [btn setUserInteractionEnabled:NO];
        if(btn == self.cameraBtn){
            myHexColor = UIColorHex(0x3BC36B);
            imageview.image = [UIImage imageNamed:@"home_root_selected"];
        }else  if(btn == self.micBtn){
            myHexColor = UIColorHex(0xF76720);
            imageview.image = [UIImage imageNamed:@"home_root_camera_normal"];
        }
        else  if(btn == self.positionBtn){
            myHexColor = UIColorHex(0x3A92FE);
            imageview.image = [UIImage imageNamed:@"home_root_mic_normal"];
        }
        [btn setBackgroundColor:myHexColor];
    });
    
}

@end

@interface LKPrivilegeManager ()

@property (assign,nonatomic) BOOL isPhoto;
@property (assign,nonatomic) BOOL isCapture;
@property (assign,nonatomic) BOOL isAudio;

@end

@implementation LKPrivilegeManager

- (void)checkAuthorization
{
    [self checkPhotoRoot:^{
        [self captureCheckRoot];
        [self audioSessionCheckRoot];
    }];
}

//相机权限
- (void)captureCheckRoot
{
    WS(weakSelf)
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {//允许访问
        weakSelf.isCapture = YES;
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted == YES) {
                weakSelf.isCapture = YES;
            }
            else
            {
                weakSelf.isCapture = NO;
            }
            
        }];
    }else  if(authStatus == AVAuthorizationStatusRestricted)
    {
        weakSelf.isCapture = NO;
    }
    else if(authStatus == AVAuthorizationStatusDenied)
    {
        weakSelf.isCapture = NO;
    }
}

- (void)checkPhotoRoot:(void(^)())complete
{
    WS(weakSelf)
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        switch (status) {
            case PHAuthorizationStatusAuthorized:
            {
                weakSelf.isPhoto = YES;
                break;
            }
            case PHAuthorizationStatusNotDetermined:
            {
                weakSelf.isPhoto = NO;
                break;
            }
            case PHAuthorizationStatusDenied:
            {
                weakSelf.isPhoto = NO;
                NSLog(@"用户拒绝当前应用访问相册,我们需要提醒用户打开访问开关");
                break;
            }
            case PHAuthorizationStatusRestricted:
            {
                weakSelf.isPhoto = NO;
                NSLog(@"家长控制,不允许访问");
                break;
            }
            default:
                break;
        }
        
        if (complete) {
            complete();
        }
        
    }];
}

//声音权限
- (void)audioSessionCheckRoot
{
    WS(weakSelf)
    __strong __typeof(weakSelf) strongSelf = weakSelf;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                strongSelf.isAudio = YES;
                [strongSelf locationCheckRoot];
            }
            else{
                strongSelf.isAudio = NO;
                [strongSelf locationCheckRoot];
            }
        }];
    }
}

//地理位置权限
- (void)locationCheckRoot
{
    lk_dispatch_main_async_safe(^{
        
        if(self.privilegeCallback)
        {
            self.privilegeCallback(self.isPhoto, self.isCapture, self.isAudio);
        }
        
//        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
//            if(_liveRootManager)
//            {
//                _liveRootManager(self.isCapture,self.isAvaudio, YES);
//            }
//        }else {
//            if(_liveRootManager)
//            {
//                _liveRootManager(self.isCapture,self.isAvaudio, NO);
//            }
//        }
    })
}

@end
