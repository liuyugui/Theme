//
//  SkinSettingManager.h
//  Theme
//
//  Created by liuyg on 2017/3/29.
//  Copyright © 2017年 liuyg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Colours.h"
#import <AFNetworking.h>
#import "ZipArchive.h"


//订阅通知的名字
#define THEME_POST @"THEME_POST"

//userdef的名字
#define THEME_USER_DEF @"themeName"

//主题配置json文件名
#define THEME_JSON_NAME @"theme.json"

@interface SkinSettingManager : NSObject

/**
 描述：颜色字典
 */
@property(nonatomic,strong)NSMutableDictionary * ColorDic;

/**
 描述：图片字典
 */
@property(nonatomic,strong)NSDictionary * ImageNameDic;

/**
 描述：json字典
 */
@property(nonatomic,strong)NSDictionary * colorJson;


+(SkinSettingManager *)sharedManager;


//需需要先订阅通知 THEME_POST

//下载主题
+ (void)downLoadThemeWithUrlStr:(NSString *)urlStr;

//拷贝默认主题
+ (void)copyDefTheme;



+ (UIColor *)colorForKey:(NSString *)key;

+ (UIColor *)themeColor;

+ (UIColor *)controllerBgColor;

+ (UIColor *)fontColor;


@end
