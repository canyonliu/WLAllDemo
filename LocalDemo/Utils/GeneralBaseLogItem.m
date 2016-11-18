//
//  GeneralBaseLogItem.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/18.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "GeneralBaseLogItem.h"
@interface GeneralBaseLogItem()
@property (nonatomic,strong) id result;
@property (nonatomic,strong) id params;

@end
@implementation GeneralBaseLogItem

- (instancetype)initWithParam:(id)params{
    if (self = [super init]) {
        //子类可以拿到然后直接使用
        self.params = params;
        self.result = [self makeResult];
    }
    return self;
}

#pragma mark 子类实现
- (id)makeResult{
    return nil;
}


#pragma mark getter And setter
//- (id)result{
//    if (!_result) {
//        _result = [[[self class]alloc]init];
//    }
//    return _result;
//}

//- (void)setResult:(id)result{
//    if (result) {
//        self.result = result;
//    }
//}

@end
