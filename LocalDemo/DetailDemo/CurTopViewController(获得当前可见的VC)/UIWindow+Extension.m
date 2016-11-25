//
//  UIWindow+Extension.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/24.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "UIWindow+Extension.h"

@implementation UIWindow (Extension)
- (id)currentTopViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = self;
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    NSLog(@"顶层responder is %@",nextResponder);
    NSLog(@"window的subviews is %@",[window subviews]);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:nextResponder forKey:@"top responder"];
    [dict setObject:[window subviews] forKey:@"subviews"];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    while (result.presentedViewController)
    {
        result = result.presentedViewController;
        
    }
    [dict setObject:result.description forKey:@"topVC"];
    
    return dict;
}

@end
