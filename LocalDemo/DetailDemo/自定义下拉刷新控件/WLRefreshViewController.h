//
//  WLRefreshViewController.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/12/1.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,WLRefreshState) {
    WLRefreshState_Waiting,
    WLRefreshState_Refreshing,
    WLRefreshState_Success,
    WLRefreshState_Failed,
    WLRefreshState_Unknown
};



@interface WLRefreshViewController : UIViewController

@end
