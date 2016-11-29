//
//  AssetsViewController.m
//  LocalDemo
//
//  Created by Liu,Qingcan on 2016/11/29.
//  Copyright © 2016年 Baidu. All rights reserved.
//

#import "AssetsViewController.h"

@interface AssetsViewController ()

@property (nonatomic,strong)UIImageView *assetsImage;

@end

@implementation AssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.assetsImage];
    
}

- (UIImageView *)assetsImage{
    if (!_assetsImage) {
        _assetsImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, 100, self.view.bounds.size.width - 100, 200)];
        [_assetsImage setImage:[UIImage imageNamed:@"guide_picture_page3"]];
    }
    return _assetsImage;
}

@end
