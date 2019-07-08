//
//  LKNavigationController.h
//  LKNovelty
//
//  Created by RoyLei on 16/11/9.
//  Copyright © 2016年 Laka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKNavigationController : UINavigationController

@property(weak,   nonatomic) id<UINavigationControllerDelegate> lvDelegate;
@property(assign, nonatomic) BOOL needFullScreenPopGesture;

@end
