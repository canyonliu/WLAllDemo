//
//  WLUnlockView.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/18.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "WLUnlockView.h"
#import "GeneralLogViewController.h"

@interface WLUnlockView()
@property (nonatomic,retain)NSMutableArray *selectedArray;
@property (nonatomic,assign)CGPoint currentPoint;

@end

@implementation WLUnlockView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
    [self setupAllButton];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupAllButton];
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupAllButton];
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat btW = 60; //bt宽
    CGFloat btH = btW; //等高
    CGFloat marginX = (self.frame.size.width - 3*btW)/4; //水平间距
    CGFloat marginY = marginX; //垂直间距等于水平间距
    
    //遍历进行布局
    for (int i= 0; i<self.subviews.count; i++) {
        NSInteger row = i/3;//行数
        NSInteger column = i%3;//列数
        UIButton *bt = self.subviews[i];
        
        bt.frame = CGRectMake(marginX+column*(marginX+btW), marginY+row*(marginY+btH), btW, btH); //每一个button对应的位置
    }
}

- (void)setupView{
    self.backgroundColor = [UIColor clearColor];
//    UIImageView *bgView = [[UIImageView alloc]initWithFrame:self.bounds];
//    [bgView setImage:[UIImage imageNamed:@"Home_refresh_bg"]];
//    self = bgView;
//    [self addSubview:bgView];
//    [self sendSubviewToBack:bgView];
    self.selectedArray = [NSMutableArray arrayWithCapacity:0];
    
}

- (void)setupAllButton{
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        button.userInteractionEnabled = NO;
        button.tag = i+1000;
        [self addSubview:button];
    }
    
}

#pragma mark 业务实现
- (CGPoint )currentTouchPoint:(NSSet <UITouch *> *)touches{

    UITouch *touch = touches.anyObject;
    return [touch locationInView:self];
}

- (UIButton *)currentResponseButton:(CGPoint)currentPoint{
    UIButton *button = nil;
    for(UIButton *subButton in self.subviews){
        if (CGRectContainsPoint(subButton.frame, currentPoint)) {
            return subButton;
        }
    }
    return button;
}

- (void)changeButtonState:(NSSet <UITouch *>*)touches{
    //    UITouch *touch = touches.anyObject;
    //    CGPoint touchPoint = [touch locationInView:self];
    CGPoint touchPoint = [self currentTouchPoint:touches];
    UIButton *touchButton = [self currentResponseButton:touchPoint];
    if (touchButton && touchButton.selected == NO) {
        touchButton.selected = YES;
        [self.selectedArray addObject:touchButton];
    }

}

#pragma mark UIRespond
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self changeButtonState:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self changeButtonState:touches];
    self.currentPoint = [self currentTouchPoint:touches];
    //需要画轨迹
    [self setNeedsDisplay];
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self saveUserLockPwd];
    
}



- (void)drawRect:(CGRect)rect{
    if (self.selectedArray && self.selectedArray.count > 0) {
        //划线
//        self.currentPoint = [self currentTouchPoint:touches];
        UIBezierPath *path = [UIBezierPath bezierPath];
        
//        [path moveToPoint:self.currentPoint];
        path.lineWidth = 5.f;
//        path
        
        for (int i = 0; i < self.selectedArray.count; i++) {
            UIButton *bt = self.selectedArray[i];
             if(i == 0){
                 [path moveToPoint:bt.center];
             }else{
                 [path addLineToPoint:bt.center];
             }
        }
        [path addLineToPoint:self.currentPoint];
        //终点处理
        [path setLineJoinStyle:kCGLineJoinRound];
        [[UIColor whiteColor]set];
        [path stroke];
        
    }
}


- (void)saveUserLockPwd{
    
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
//    [userDefaluts setObject:pwdArr forKey:@"user_password"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *string = @"";
    if (self.selectedArray.count) {
        for (int i = 0; i < self.selectedArray.count; i++) {
            UIButton *bt = self.selectedArray[i];
            //        string = [NSString stringWithFormat:@"tag_%ld",bt.tag];
            bt.selected = NO;
            string = [string stringByAppendingString:[NSString stringWithFormat:@"t_%ld_",(long)bt.tag]];
        }
        NSString *userPwd = [userDefaluts objectForKey:@"user_password"];
        NSString *msg;
        if (userPwd) {
            if ([string isEqualToString:userPwd]) {
                NSLog(@"it's ture");
                msg = @"密码正确！";
            }else{
                NSLog(@"it's wrong");
                msg = @"密码错误~";
            }
            
            
        }else{
            msg = @"您的密码已经被记录，请熟记！";
            [userDefaluts setObject:string forKey:@"user_password"];
        }
        
        GeneralLogViewController *logVC = [GeneralLogViewController initWithTitle:@"提示信息" detailTitle:msg];
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *vc = nav.viewControllers.firstObject;
        [vc presentViewController:logVC animated:YES completion:nil];

 
    }
    //清除线
    [self.selectedArray removeAllObjects];
    
    [self setNeedsDisplay];
 
 
//    });
    
    
}




@end
