//
//  WLRefreshView.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/12/2.
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


@interface WLRefreshView : UIView
//refresh相关
@property (nonatomic,strong)UILabel *refreshLabel;
@property (nonatomic,strong)NSString *refreshTitle;
@property (nonatomic,strong)UIImageView *refreshImage;
@property (nonatomic,strong)UIImageView *refreshBackImage;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL isAnimation;



@end
