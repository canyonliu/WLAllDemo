//
//  UniqueString.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/17.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "UniqueString.h"

@implementation UniqueString

- (instancetype)init{
    if ([super init]) {
        self.result = [self testForUniqueString];
    }
    
    return self;
}

/**
 利用洗牌算法生成随机数
 */
- (NSString *)testForUniqueString{
    //    NSString *resultString = @"";
    ////    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    //
    //    NSMutableArray *originArray = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
    //
    //
    //
    //
    //    NSInteger randomCount = 6;
    //    for (int index = 0; index < randomCount; index++) {
    //        NSInteger t = arc4random()%originArray.count;
    //        NSString *str = [NSString stringWithFormat:@"%@",[originArray objectAtIndex:t]];
    //
    //        resultString = [resultString stringByAppendingString:str];
    //        originArray[t] = [originArray lastObject];
    //        [originArray removeLastObject];
    //    }
    //
    //    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    //    NSString *timeString = [NSString stringWithFormat:@"%f",time];
    //
    //    [resultString stringByAppendingString:timeString];
    //
    
    
    NSString *resultString = [NSString string];
//    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    NSMutableArray *originArray = [[NSMutableArray alloc]initWithObjects:@1,@2,@3,@4,@5,@6,nil];
    NSInteger randomCount = 6;
    for (int index = 0; index < randomCount; index++) {
        NSInteger t = arc4random()%originArray.count;
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@", [originArray objectAtIndex:t]]];
        originArray[t] = [originArray lastObject];
        [originArray removeLastObject];
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",time];
    
    resultString = [resultString stringByAppendingString:timeString];
    
//    [resultDict setObject:resultString forKey:@"rootTag"];
    return resultString;
    
}


@end
