//
//  WLIbeaconItem.h
//  LocalDemo
//
//  Created by QingCan on 2017/12/16.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@interface WLIbeaconItem : NSObject<NSCoding>
@property (nonatomic,strong,readonly)NSString *name;
@property (nonatomic,strong,readonly)NSUUID *uuid;
@property (nonatomic,assign,readonly)CLBeaconMajorValue majorValue;
@property (nonatomic,assign,readonly)CLBeaconMinorValue minorValue;



@property (strong, nonatomic) CLBeacon *lastSeenBeacon;
+ (instancetype)ibeconItemWithName:(NSString *)name uuid:(NSUUID *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor;

- (BOOL)isEqualToCLBeacon:(CLBeacon *)beacon;

@end
