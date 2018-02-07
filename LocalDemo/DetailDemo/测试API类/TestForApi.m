//
//  TestForApi.m
//  LocalDemo
//
//  Created by QingCan on 2017/7/11.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "TestForApi.h"

@implementation TestForApi

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)makeResult{
    CGSize r =  [self calculateDefalutRectContent:@"baidu" fontSize:13];
    NSString *str = [NSString stringWithFormat:@"%f,-- %f",r.width,r.height];
    return str;
}


/**
 测试一个行字固定行号的高度是多少
 @param content <#content description#>
 @param fontSize <#fontSize description#>
 @return <#return value description#>
 */
- (CGSize)calculateDefalutRectContent:(NSString *)content fontSize:(CGFloat)fontSize{
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return titleSize;
}

/**
 测试 cherry-pick操作
 second
 */


@end
