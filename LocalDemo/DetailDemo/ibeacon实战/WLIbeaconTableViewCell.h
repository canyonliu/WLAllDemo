//
//  WLIbeaconTableViewCell.h
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLIbeaconItem.h"
@interface WLIbeaconTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *uuid;
@property (nonatomic,strong)WLIbeaconItem *item;
@end
