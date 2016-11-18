//
//  CalenderDataSource.m
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import "CalenderDataSource.h"
#import "SampleDayEvent.h"
//#import "WLCollectionViewCell.h"
@interface CalenderDataSource()

@property (strong,nonatomic) NSMutableArray *events;

@end

@implementation CalenderDataSource

-(instancetype )init{
    _events = [[NSMutableArray alloc]init];
    
    
    [self generateSampleData];
    

    return self;
}

//- (void)awakeFromNib{
//    _events = [[NSMutableArray alloc]init];
//    
//    
//    [self generateSampleData];
//    
//}

- (void)generateSampleData{
    for (NSUInteger i = 0; i < 15; i++){
        SampleDayEvent *singleEvent = [SampleDayEvent initSampleData];
        [_events addObject:singleEvent];
    }
}


#pragma mark Public

- (id <CalenderEvent>)eventWithIndexpath:(NSIndexPath *)indexPath{
    return _events[indexPath.item];
}


- (NSArray *)indexPathsOfEventsBetweenMinDayIndex:(NSInteger)minDayIndex maxDayIndex:(NSInteger)maxDayIndex minStartHour:(NSInteger)minStartHour maxStartHour:(NSInteger)maxStartHour{
    
    NSMutableArray *dexArray = [NSMutableArray array];
    
    [_events enumerateObjectsUsingBlock:^(id  _Nonnull event, NSUInteger idx, BOOL * _Nonnull stop) {
        if([event day] >= minDayIndex && [event day] <= maxDayIndex && [event startHour] >= minStartHour && [event startHour] <= maxStartHour){
            NSIndexPath *index = [NSIndexPath indexPathForItem:idx inSection:0];
            [dexArray addObject:index];
        }
    }];
    
    return dexArray;
}


#pragma mark UICollectionViewDataSource

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return _events.count;
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _events.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    id <CalenderEvent> event = _events[indexPath.item];
    
    if(self.configureCellBlock){
        _configureCellBlock(cell,indexPath,event);
    }

    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    if (self.configureHeaderViewBlock) {
        _configureHeaderViewBlock(headView, kind,indexPath);
    }
    return headView;
    
}




@end

