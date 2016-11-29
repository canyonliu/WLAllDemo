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
        //使用guide_word_page3.png 和 guide_word_page3都是可以的，但是就是不能使用
        //        guide_word_page3@2x.png,尽管在xcassets中是含有2x的，但是在json的文件描述之中：
//        | "filename" : "guide_word_page3@2x.png",
//        |  "scale" : "2x"
//        是会把名为guide_word_page3@2x.png的图片自动的放到手机为2x的中去
        [_assetsImage setImage:[UIImage imageNamed:@"guide_word_page3.png"]];
    }
    return _assetsImage;
}

@end
