//
//  SampleDayEvent.m
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import "SampleDayEvent.h"

@implementation SampleDayEvent
@synthesize day = _day;
@synthesize title = _title;
@synthesize startHour = _startHour;
@synthesize durationHours = _durationInHours;
@synthesize selectBlock = _selectBlock;

+ (instancetype)initSampleData{
    uint32_t randomId = arc4random_uniform(10000);
    uint32_t randomDay = arc4random_uniform(7);
    uint32_t randomStartHour = arc4random_uniform(20);
    uint32_t randomDurationHour = arc4random_uniform(5)+1;
    
    NSString *randomTitle = [NSString stringWithFormat:@"WLEvent - %u",randomId];
    return [self initWithTile:randomTitle day:randomDay startHour:randomStartHour durationHour:randomDurationHour];
}

+ (instancetype)initWithTile:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationHour:(NSUInteger)durationHour{
    return [[self alloc]initWithTile:title day:day startHour:startHour durationHour:durationHour];
    
}

- (instancetype)initWithTile:(NSString *)title day:(NSUInteger)day startHour:(NSUInteger)startHour durationHour:(NSUInteger)durationHour{
    self = [super init];
    if (self) {
    
    _day = day;
    _durationInHours = durationHour;
    _title = title;
    _startHour = startHour;
    
    }
    return self;
    
}

@end
