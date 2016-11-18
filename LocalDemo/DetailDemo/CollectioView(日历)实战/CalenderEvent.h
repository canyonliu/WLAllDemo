//
//  CalenderEvent.h
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  CalenderEvent<NSObject>
typedef void  (^didSelectEventBlock)(void);


@property (nonatomic,strong)NSString *title;
@property (nonatomic,assign)NSUInteger day;
@property (nonatomic,assign)NSUInteger startHour;
@property (nonatomic,assign)NSUInteger durationHours;
@property (nonatomic,copy)didSelectEventBlock selectBlock;


@end
