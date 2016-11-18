//
//  CalenderDataSource.h
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLCollectionViewCell.h"
#import "HeaderView.h"
#import "SampleDayEvent.h"

typedef void (^ConfigureCellBlock) (WLCollectionViewCell *cell,NSIndexPath *indexPath,id<CalenderEvent> event);

typedef void(^ConfigureHeaderViewBlock)(HeaderView *headerView,NSString *kind,NSIndexPath *indexPath);




@interface CalenderDataSource : NSObject<UICollectionViewDataSource>

@property (copy,nonatomic) ConfigureCellBlock configureCellBlock;

@property (copy,nonatomic) ConfigureHeaderViewBlock
                configureHeaderViewBlock;

- (id<CalenderEvent>)eventWithIndexpath:(NSIndexPath *)indexPath;

- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour;



@end
