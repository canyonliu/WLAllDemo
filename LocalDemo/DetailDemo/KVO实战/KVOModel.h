//
//  KVOModel.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralBaseLogItem.h"
typedef NSString * (^KVOBlock)(NSString *);

@interface KVOModel : GeneralBaseLogItem
@property (nonatomic,copy) KVOBlock kvoBlcok;
@property (nonatomic,strong,readonly) NSString *name;

@end
