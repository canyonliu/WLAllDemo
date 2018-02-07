//
//  WLIbeaconItem.m
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "WLIbeaconItem.h"

@interface WLIbeaconItem()
@property (nonatomic,strong,readwrite)NSString *name;
@property (nonatomic,strong,readwrite)NSUUID *uuid;
@property (nonatomic,assign,readwrite)CLBeaconMajorValue majorValue;
@property (nonatomic,assign,readwrite)CLBeaconMinorValue minorValue;
@end

@implementation WLIbeaconItem
#pragma mark conform NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.majorValue = [aDecoder decodeIntegerForKey:@"majorValue"];
        self.minorValue = [aDecoder decodeIntegerForKey:@"minorValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeInteger:self.majorValue forKey:@"majorValue"];
    [aCoder encodeInteger:self.minorValue forKey:@"minorValue"];
}


+ (instancetype)ibeconItemWithName:(NSString *)name uuid:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor{
    return [[self alloc] initWithName:name uuid:uuid major:major minor:minor];
}

- (instancetype)initWithName:(NSString *)name uuid:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor{
    self = [super init];
    if (self) {
        self.name = name;
        self.uuid = uuid;
        self.majorValue = major;
        self.minorValue = minor;
        
    }
    return self;
}


- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon {
    if ([[beacon.proximityUUID UUIDString] isEqualToString:[self.uuid UUIDString]]
//        &&
//        [beacon.major isEqual: @(self.majorValue)] &&
//        [beacon.minor isEqual: @(self.minorValue)]
        )
    {
        return YES;
    } else {
        return NO;
    }
}

@end
