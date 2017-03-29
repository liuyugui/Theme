//
//  UIImage+Theme.m
//  Theme
//
//  Created by 法大大 on 2017/3/29.
//  Copyright © 2017年 liuyg. All rights reserved.
//

#import "UIImage+Theme.h"

@implementation UIImage (Theme)

+ (UIImage *)imageWithThemeName:(NSString *)name{

    NSString * imageName = [[SkinSettingManager sharedManager].ImageNameDic objectForKey:name];

    //获取沙盒的Documents
    NSString * docmentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //获取下载的主题名字
    NSString * theme = [[NSUserDefaults standardUserDefaults]objectForKey:@"themeName"];
    //获取主题目录
    NSString * themeStr = [NSString stringWithFormat:@"%@/theme/%@/img",docmentsDir,theme];
    
    
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",themeStr,imageName]];
}

@end
