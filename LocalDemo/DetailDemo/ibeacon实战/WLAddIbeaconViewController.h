//
//  WLAddIbeaconViewController.h
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLIbeaconItem.h"
//typedef  void(^addItemCompletionBlock)(WLIbeaconItem *item);

@interface WLAddIbeaconViewController : UIViewController

@property (nonatomic,copy) void(^addItemCompletionBlock)(WLIbeaconItem *item);
@end
