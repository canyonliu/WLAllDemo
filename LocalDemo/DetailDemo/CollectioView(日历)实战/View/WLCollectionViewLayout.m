//
//  WLCollectionViewLayout.m
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import "WLCollectionViewLayout.h"


static const CGFloat HorizontalSpacing = 10;
static const CGFloat HeightPerHour = 35;
static const CGFloat DayHeaderHeight = 30;
static const CGFloat HourHeaderWidth = 35;
static const NSUInteger DaysPerWeek = 7;
static const NSUInteger HoursPerDay = 24;

//@interface WLCollectionViewLayout()
//
//
//@end
//

@implementation WLCollectionViewLayout

//- (void)prepareLayout{
//    CalenderDataSource *datasource = [[CalenderDataSource alloc]init];
//    self.collectionView.dataSource = datasource;
//}


- (CGSize )collectionViewContentSize{
    CGFloat width = self.collectionView.bounds.size.width;
    CGFloat height = HoursPerDay * HeightPerHour + DayHeaderHeight;
    CGSize contentSize = CGSizeMake(width, height);
    
    return contentSize;
}

#pragma mark layout implementation

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *layoutAttributes = [NSMutableArray array];
    
    NSArray *visibleIndexPaths = [self indexPathsOfItemsInRect:rect];
    //可见cell的attribute
    for(NSIndexPath *path in visibleIndexPaths){
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:path];
        [layoutAttributes addObject:attribute];
    }
    
    //supplementation -- DayHeader
    NSArray *visibleDayHeaderPaths = [self indexpathsOfSupplementarysInRect:rect];
    for (NSIndexPath *path in visibleDayHeaderPaths) {
//        UICollectionViewLayoutAttributes *attibute = [self layoutAttributesForElementsInRect:rect];
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"DayHeaderView" atIndexPath:path];
        [layoutAttributes addObject:attributes];
    }
    
    //supplementation -- HourHeader
    
    NSArray *visibleHourHeaderPaths = [self indexpathOfSupplementaryHourInRect:rect];
    
    for(NSIndexPath *path in visibleHourHeaderPaths){
                UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"HourHeaderView" atIndexPath:path];
        [layoutAttributes addObject:attributes];
    }
    
    
    
    
    
    
    return layoutAttributes;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    CalenderDataSource *dataSource = (CalenderDataSource *)self.collectionView.dataSource;
    id <CalenderEvent> event = [dataSource eventWithIndexpath:indexPath];
    
    UICollectionViewLayoutAttributes *layoutAttribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttribute.frame = [self frameWithEvent:event];
    return layoutAttribute;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    CGFloat totalWidth = [self collectionViewContentSize].width;
    if ([kind isEqualToString:@"DayHeaderView"]) {
        CGFloat availableWidth = totalWidth - HourHeaderWidth;
        CGFloat widthPerDay = availableWidth / DaysPerWeek;
        attributes.frame = CGRectMake(HourHeaderWidth + (widthPerDay * indexPath.item), 0, widthPerDay, DayHeaderHeight);
        attributes.zIndex = -10;
    } else if ([kind isEqualToString:@"HourHeaderView"]) {
        attributes.frame = CGRectMake(0, DayHeaderHeight + HeightPerHour * indexPath.item, totalWidth, HeightPerHour);
        attributes.zIndex = -10;
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}





#pragma mark - Helpers

- (NSArray *)indexPathsOfItemsInRect:(CGRect)rect
{
    NSInteger minVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxVisibleDay = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSInteger minVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxVisibleHour = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    
//        NSLog(@"rect: %@, days: %ld-%ld, hours: %ld-%ld", NSStringFromCGRect(rect), (long)minVisibleDay, (long)maxVisibleDay, (long)minVisibleHour, (long)maxVisibleHour);
    
    CalenderDataSource *dataSource = self.collectionView.dataSource;
    NSArray *indexPaths = [dataSource indexPathsOfEventsBetweenMinDayIndex:minVisibleDay maxDayIndex:maxVisibleDay minStartHour:minVisibleHour maxStartHour:maxVisibleHour];
    return indexPaths;
}


- (NSInteger)dayIndexFromXCoordinate:(CGFloat)xPosition{
    CGFloat width = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = width / DaysPerWeek;
//    第几天
    NSInteger dayIndex = MAX((NSInteger)0, (NSInteger)(xPosition -HourHeaderWidth)/widthPerDay);
    return dayIndex;
    
}

- (NSInteger)hourIndexFromYCoordinate:(CGFloat)yPosition{
//    第几个小时
    NSInteger hourIndex = MAX((NSInteger)0, (NSInteger)(yPosition - DayHeaderHeight)/HeightPerHour);
    return hourIndex;
}


- (NSArray *)indexpathsOfSupplementarysInRect:(CGRect)rect{
    if(CGRectGetMinX(rect)>DayHeaderHeight){
        return [NSArray array];
        
    }
    NSInteger minDayIndex = [self dayIndexFromXCoordinate:CGRectGetMinX(rect)];
    NSInteger maxDayIndex = [self dayIndexFromXCoordinate:CGRectGetMaxX(rect)];
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for (NSInteger idx = minDayIndex; idx < maxDayIndex; idx++) {
        [indexArray addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }
    
    
    
    
    return indexArray;
    
}

- (NSArray *)indexpathOfSupplementaryHourInRect:(CGRect)rect{
    if(CGRectGetMinY(rect)>HourHeaderWidth){
        return [NSArray array];
        
    }
    NSInteger minHourIndex = [self hourIndexFromYCoordinate:CGRectGetMinY(rect)];
    NSInteger maxHourIndex = [self hourIndexFromYCoordinate:CGRectGetMaxY(rect)];
    NSMutableArray *indexArray = [NSMutableArray array];
    
    for(NSInteger idx = minHourIndex; idx < maxHourIndex; idx++){
        [indexArray addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
    }
    
    return indexArray;
}


- (CGRect)frameWithEvent:(id<CalenderEvent>) event{
    CGFloat totalWidth = [self collectionViewContentSize].width - HourHeaderWidth;
    CGFloat widthPerDay = totalWidth / DaysPerWeek;
    
    CGRect frame = CGRectZero;
    frame.origin.x = HourHeaderWidth + widthPerDay * event.day;
    frame.origin.y = DayHeaderHeight + HeightPerHour * event.startHour;
    frame.size.width = widthPerDay;
    frame.size.height = [event durationHours] * HeightPerHour;
    
    frame = CGRectInset(frame, HorizontalSpacing/2.0, 0);
    return frame;
}

@end
