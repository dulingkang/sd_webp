//
//  ViewController.m
//  sd_webpDemo
//
//  Created by ShawnDu on 2016/12/1.
//  Copyright © 2016年 Shawn Du. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+WebP.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SDImageCache sharedImageCache] cleanDisk];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    NSString *str1 = @"https://devthinking.com/images/animated.webp";
    str1 = @"https://img.dmall.com/mIndex/201612/a3f819c6-f055-46f0-bd56-4586830bdc45_240x240H.webp";
    [imageview sd_setImageWithURL:[NSURL URLWithString:str1]];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageview];
    
//    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 200, 200)];
//    [imageView1 sd_setImageWithURL:[NSURL URLWithString:@"https://devthinking.com/images/test1.webp"]];
//    imageView1.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:imageView1];
    
//    [self addWebView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)addWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 200, ScreenWidth, ScreenHeight - 200)];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://devthinking.com/testWebp.html"]];
    // 3.加载网页
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

@end
