//
//  LKPrivilegeTipsView.h
//  Live
//
//  Created by iOS on 16/4/5.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKPrivilegeTipsView : UIView

@property (nonatomic, copy) void (^closePrivilegeView)();

- (void)setupPrivileges:(NSArray *)privileges;

@end


@interface LKPrivilegeManager : NSObject

@property (assign, nonatomic, readonly) BOOL isPhoto;
@property (assign, nonatomic, readonly) BOOL isCapture;
@property (assign, nonatomic, readonly) BOOL isAudio;

@property (nonatomic, copy) void (^privilegeCallback)(BOOL ,BOOL,BOOL);

/**
 执行检测权限
 */
- (void)checkAuthorization;

@end
