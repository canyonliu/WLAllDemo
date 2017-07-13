//
//  WLCollectionViewCell.m
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import "WLCollectionViewCell.h"

@implementation WLCollectionViewCell

//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if ([super initWithCoder:aDecoder]) {
//        [self setup];
//    }
//    
//    return self;
//}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if([super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup{
   
    self.layer.cornerRadius = 15;
    self.layer.borderColor =  [[UIColor colorWithRed:0 green:0 blue:0.7 alpha:1] CGColor];
    self.layer.borderWidth = 2.0f;
}

- (UILabel *)cellTextLabel{
    
    if (_cellTextLabel == nil) {
        _cellTextLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _cellTextLabel.textAlignment = NSTextAlignmentLeft;
        _cellTextLabel.layer.cornerRadius = self.layer.cornerRadius;
        _cellTextLabel.layer.masksToBounds = YES;
        _cellTextLabel.backgroundColor = [UIColor orangeColor];
        _cellTextLabel.font = [UIFont boldSystemFontOfSize:8];
         [self addSubview:_cellTextLabel];
    }
    return _cellTextLabel;
}

@end
