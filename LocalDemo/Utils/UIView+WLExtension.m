//
//  UIView+WLExtension.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/22.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "UIView+WLExtension.h"

@implementation UIView (WLExtension)
- (void)setWL_x:(CGFloat)WL_x{
    CGRect frame = self.frame;
    frame.origin.x = WL_x;
    self.frame = frame;
}

- (void)setWL_y:(CGFloat)WL_y{
    CGRect frame = self.frame;
    frame.origin.y = WL_y;
    self.frame = frame;
}

- (void)setWL_width:(CGFloat)WL_width{
    CGRect frame = self.frame;
    frame.size.width = WL_width;
    self.frame = frame;
}

- (void)setWL_height:(CGFloat)WL_height{
    CGRect frame = self.frame;
    frame.size.height = WL_height;
    self.frame = frame;
}

- (CGFloat)WL_x{
    return self.frame.origin.x;
}

- (CGFloat)WL_y{
    return self.frame.origin.y;
}

- (CGFloat)WL_width{
    return self.frame.size.width;
}

- (CGFloat)WL_height{
    return self.frame.size.height;
}

- (CGFloat)WL_centerX{
    return self.center.x;
}
- (void)setWL_centerX:(CGFloat)WL_centerX{
    CGPoint center = self.center;
    center.x = WL_centerX;
    self.center = center;
}

- (CGFloat)WL_centerY{
    return self.center.y;
}
- (void)setWL_centerY:(CGFloat)WL_centerY{
    CGPoint center = self.center;
    center.y = WL_centerY;
    self.center = center;
}

- (void)setWL_size:(CGSize)WL_size{
    CGRect frame = self.frame;
    frame.size = WL_size;
    self.frame = frame;
}
- (CGSize)WL_size{
    return self.frame.size;
}


- (CGFloat)WL_right{
    //    return self.WL_x + self.WL_width;
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)WL_bottom{
    //    return self.WL_y + self.WL_height;
    return CGRectGetMaxY(self.frame);
}

- (void)setWL_right:(CGFloat)WL_right{
    self.WL_x = WL_right - self.WL_width;
}
- (void)setWL_bottom:(CGFloat)WL_bottom{
    self.WL_y = WL_bottom - self.WL_height;
}

+ (instancetype)WL_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
@end
