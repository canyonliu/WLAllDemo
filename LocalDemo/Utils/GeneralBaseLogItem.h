//
//  GeneralBaseLogItem.h
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/18.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralBaseLogItem : NSObject
@property (nonatomic,strong,readonly) id result;

- (id)makeResult;

- (instancetype)initWithParam:(id)params;
@end
