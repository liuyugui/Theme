//
//  ViewController.m
//  Theme
//
//  Created by 法大大 on 2017/3/29.
//  Copyright © 2017年 liuyg. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

#import "SkinSettingManager.h"
#import "ZipArchive.h"

#import "UIImage+Theme.h"


//-------------------   宏 -------------------------
//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface ViewController ()


/**
 描述：<#描述#>
 */
@property(nonatomic,strong)UIImageView * msgImageView;

/**
 描述：<#描述#>
 */
@property(nonatomic,strong)UILabel * msgLable;


/**
 描述：<#描述#>
 */
@property(nonatomic,strong)UIView * topView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //订阅通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemeNotification:) name:THEME_POST object:nil];
    
    
    self.msgImageView = [[UIImageView alloc]init];
    [self.view addSubview:self.msgImageView];
    self.msgImageView.frame = CGRectMake(0, 260, 100, 100);
    
    self.msgLable = [[UILabel alloc]init];
    [self.view addSubview:self.msgLable];
    self.msgLable.frame = CGRectMake(0, 360, 100, 100);
    self.msgLable.text = @"测试下";
    
    self.topView = [[UIView alloc]init];
    [self.view addSubview:self.topView];
    self.topView.frame = CGRectMake(0, 360, 100, 200);
    
    
    UIButton * garyDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:garyDownBtn];
    garyDownBtn.frame = CGRectMake(10, 100, 100, 40);
    [garyDownBtn setTitle:@"灰色主题" forState:UIControlStateNormal];
    garyDownBtn.tag = 111;
    [garyDownBtn addTarget:self action:@selector(downTheme:) forControlEvents:UIControlEventTouchUpInside];
    [garyDownBtn setBackgroundColor:[UIColor grayColor]];
    
    
    UIButton * redDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:redDownBtn];
    redDownBtn.frame = CGRectMake(10, 200, 100, 40);
    [redDownBtn setTitle:@"红色主题" forState:UIControlStateNormal];
    redDownBtn.tag = 222;
    [redDownBtn addTarget:self action:@selector(downTheme:) forControlEvents:UIControlEventTouchUpInside];
    [redDownBtn setBackgroundColor:[UIColor redColor]];
    
    
    //复制默认主题
    [SkinSettingManager copyDefTheme];
    
}


//主题变更时处理的方法
- (void)changeThemeNotification:(NSNotification *)notofacetion{
    
    UIImage *savedImage = [UIImage imageWithThemeName:@"phone"];
    
    self.msgImageView.image = savedImage;
    
    self.view.backgroundColor = [SkinSettingManager themeColor];
    self.msgLable.textColor = [SkinSettingManager fontColor];
}


//下载
- (void)downTheme:(UIButton *)sender{
    
    //下载地址
    NSString * fileUrl;
    if (sender.tag == 111) {
        fileUrl = [NSString stringWithFormat:@"http://192.168.9.55/theme/gayTheme.zip"];
    }else{
        fileUrl = [NSString stringWithFormat:@"http://192.168.9.55/theme/redTheme.zip"];
    }
    
    //下载主题
    [SkinSettingManager downLoadThemeWithUrlStr:fileUrl];
    
}



@end
