//
//  WLCollectionViewController.m
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import "WLCollectionViewController.h"
#import "WLCollectionViewCell.h"
#import "HeaderView.h"
#import "CalenderDataSource.h"
#import "WLCollectionViewLayout.h"
#import "WLCollectioView.h"


@interface WLCollectionViewController ()<UICollectionViewDelegate>
@property (strong, nonatomic)  CalenderDataSource *calendarDataSource;

@property (strong, nonatomic) WLCollectioView *myCollectionView;

@end

@implementation WLCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myCollectionView];
    
    
    
    
    // setting layout
//    WLCollectionViewLayout *layout = [[WLCollectionViewLayout alloc]init];
//    _collectionView = [[self.collectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
//    NSLog(@"=====%ld",layout.collectionViewContentSize.height);
    
    
//    CalenderDataSource *dataSource = [[CalenderDataSource alloc]init];
//    self.collectionView.dataSource = dataSource;
    CalenderDataSource *dataSource = (CalenderDataSource *) self.myCollectionView.dataSource;
    

    
    dataSource.configureCellBlock = ^(WLCollectionViewCell *cell,NSIndexPath *indexPath,id<CalenderEvent>event){
        cell.cellTextLabel.text = event.title;
        event.selectBlock = ^(){
            cell.cellTextLabel.text = @"lqc";
        };
    };
    
    dataSource.configureHeaderViewBlock = ^(HeaderView *headerView,NSString *kind,NSIndexPath *indexPath){
        if ([kind isEqualToString:@"DayHeaderView"]) {
            headerView.textLabel.text = [NSString stringWithFormat:@"星期 %ld", indexPath.item + 1];
        } else if ([kind isEqualToString:@"HourHeaderView"]) {
            headerView.textLabel.text = [NSString stringWithFormat:@"%ld时", indexPath.item + 1];
        }
        
    };
    
    
    
    
    
    
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id<CalenderEvent> selectEvent = [(CalenderDataSource *)(collectionView.dataSource) eventWithIndexpath:indexPath];
    if (selectEvent.selectBlock) {
        selectEvent.selectBlock();
    }
}




#pragma mark getter

- (WLCollectioView *)myCollectionView{
    if (!_myCollectionView) {
        WLCollectionViewLayout *layout = [[WLCollectionViewLayout alloc]init];
        _myCollectionView = [[WLCollectioView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor lightGrayColor];
        _myCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _myCollectionView.showsVerticalScrollIndicator = YES;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        
        _myCollectionView.dataSource = self.calendarDataSource;
        _myCollectionView.delegate = self;
        
        
        Class cellCls = [WLCollectionViewCell class];
        [_myCollectionView registerClass:cellCls forCellWithReuseIdentifier:@"cell"];
        
        Class headerCls = [HeaderView class];
        [_myCollectionView registerClass:headerCls forSupplementaryViewOfKind:@"DayHeaderView" withReuseIdentifier:@"HeaderView"];
        [_myCollectionView registerClass:headerCls forSupplementaryViewOfKind:@"HourHeaderView" withReuseIdentifier:@"HeaderView"];
        


        
    }
    return _myCollectionView;
}

- (CalenderDataSource *)calendarDataSource{
    if (!_calendarDataSource) {
        _calendarDataSource = [[CalenderDataSource alloc]init];
    }
    return _calendarDataSource;
}


@end
