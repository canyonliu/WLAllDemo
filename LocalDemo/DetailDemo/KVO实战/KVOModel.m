//
//  KVOModel.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/25.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "KVOModel.h"
@interface KVOModel()

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *returnResult;
@end

@implementation KVOModel

- (id)makeResult{
    self.name = @"5s后这个值会变，初始值是：lqc";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.kvoBlcok) {
            [self performSelector:@selector(returnBlock) withObject:nil afterDelay:2.f];
        }
        self.name = @"5s后的值是：wayne";

    });
    
    return self.name;
}

- (void)returnBlock{
    self.returnResult = self.kvoBlcok(@"model和View之间的交互，使用Block比KVO更好\n KVO在VC和Model之间交互更能发挥效用\n 此函数说明了合理使用setter方法是可以不刷新的情况下改变界面上的元素的");
    NSLog(@"returnResult: %@",self.returnResult);

}


@end
