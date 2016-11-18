//
//  HeaderView.m
//  CollectionViewDemo
//
//  Created by Liu,Qingcan on 2016/10/28.
//  Copyright © 2016年 LiuQingcan. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
    [self addSubview:self.textLabel];
    }
    
    return self;
}

-(UILabel *)textLabel{
    
    
    if(_textLabel == nil){
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    self.textLabel.backgroundColor = [UIColor greenColor];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _textLabel;
}
@end
