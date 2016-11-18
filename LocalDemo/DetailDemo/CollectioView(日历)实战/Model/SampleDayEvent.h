//
//  SampleDayEvent.h
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalenderEvent.h"
@interface SampleDayEvent : NSObject<CalenderEvent>

+ (instancetype)initSampleData;

- (instancetype)initWithTile:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationHour:(NSUInteger)durationHour;

+ (instancetype)initWithTile:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationHour:(NSUInteger)durationHour;

@end
