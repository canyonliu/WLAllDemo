//
//  WLSpotlight.m
//  LocalDemo
//
//  Created by QingCan on 2017/7/20.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "WLSpotlight.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface WLSpotlight ()

@end

@implementation WLSpotlight

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self supportForSpotlightSearch];
}

- (void)supportForSpotlightSearch{
    NSArray *activityItem = @[@"火影-百度",@"火影-阿里",@"火影-腾讯"];
    
    NSMutableArray *searchItemArr = [[NSMutableArray alloc]initWithCapacity:activityItem.count];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//    dispatch_queue_t queue1 = dispatch_queue_create("com.baidu.chge", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        @try {
            for (int index = 0; index < activityItem.count; index++) {
                //1.创建条目的属性集合
                CSSearchableItemAttributeSet * itemSet = [[CSSearchableItemAttributeSet alloc]initWithItemContentType:(NSString *)kUTTypeImage];
                //2.给属性集合添加属性
                itemSet.title = activityItem[index];
                itemSet.contentDescription = [NSString stringWithFormat:@"chge 与 %@",activityItem[index]];
                itemSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:[NSString stringWithFormat:@"h%d",index+1]]);
                //3.属性集合与条目进行关联
                CSSearchableItem *searchItem = [[CSSearchableItem alloc]initWithUniqueIdentifier:[NSString stringWithFormat:@"%d",index] domainIdentifier:@"chge.searchSpotilightDemo" attributeSet:itemSet];
                [searchItemArr addObject:searchItem];
            }
            
            [[CSSearchableIndex defaultSearchableIndex]indexSearchableItems:searchItemArr completionHandler:^(NSError * _Nullable error) {
                if (!error) {
                    NSLog(@"%s,%@",__FUNCTION__,[error localizedDescription]);
                }
            }];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    });
    
    
}

@end
