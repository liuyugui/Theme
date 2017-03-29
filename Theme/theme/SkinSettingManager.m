//
//  SkinSettingManager.m
//  Theme
//
//  Created by 法大大 on 2017/3/29.
//  Copyright © 2017年 liuyg. All rights reserved.
//

#import "SkinSettingManager.h"


@interface SkinSettingManager()

@end


@implementation SkinSettingManager

+ (SkinSettingManager *)sharedManager {
    
    SkinSettingManager * manager = [[SkinSettingManager alloc]init];
    
    //获取沙盒的Documents
    NSString * docmentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //获取下载的主题名字
    NSString * theme = [[NSUserDefaults standardUserDefaults]objectForKey:THEME_USER_DEF];
    //获取主题目录
    NSString * themeStr = [NSString stringWithFormat:@"%@/theme/%@",docmentsDir,theme];
    //获取选择的主题目录
    NSString *strPath = [NSString stringWithFormat:@"%@/%@",themeStr,THEME_JSON_NAME];
    //生成data
    NSData *data = [[NSData alloc]initWithContentsOfFile:strPath];
    //转成字典
    manager.colorJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //生成可变颜色字典
    manager.ColorDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = (NSDictionary *)manager.colorJson[@"colors"];
    //循环遍历颜色字典
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL * _Nonnull stop) {
        
        [manager.ColorDic setValue:[UIColor colorFromHexString:obj] forKey:key];
    }];
    
    //生成图片字典
    manager.ImageNameDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)manager.colorJson[@"images"]];
    

    return manager;
}


//下载主题
+ (void)downLoadThemeWithUrlStr:(NSString *)urlStr{

//判断是否已经下载过主题
    //截取字符串
    NSArray *urlArray = [urlStr componentsSeparatedByString:@"/"];
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * docFilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,[urlArray lastObject]];
    
    if([fileManager fileExistsAtPath:docFilePath]){
        
        NSLog(@"主题已经下载");
        
        //主题名字
        NSArray *fileArray = [[urlArray lastObject] componentsSeparatedByString:@"."];
        [[NSUserDefaults standardUserDefaults]setValue:[fileArray firstObject] forKey:THEME_USER_DEF];
       
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME_POST object:nil];
        
        return;
    }
    
    
//开始下载
    //url
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //保存路径
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载Task操作
    [[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        
        return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",documentsPath,response.suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsPath = [docPath objectAtIndex:0];
        NSString * path = [NSString stringWithFormat:@"%@/%@",documentsPath,response.suggestedFilename];
        
        //解压
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        [zipFile UnzipOpenFile:path];
        NSString *unzipPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"theme"];
        [zipFile UnzipFileTo:unzipPath overWrite:true];
        [zipFile UnzipCloseFile];
        
        
        [[NSUserDefaults standardUserDefaults]setValue:[[path lastPathComponent] stringByDeletingPathExtension] forKey:THEME_USER_DEF];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME_POST object:nil];
        
    }] resume];

}


+ (void)copyDefTheme{
    
    //判断是否已经设置过主题了
    if (((NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:THEME_USER_DEF]).length > 0) {
        
        NSLog(@"已经设置主题");
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME_POST object:nil];
        
        return;
    }
    
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *defThemePath = [mainBundle pathForResource:@"defTheme" ofType:@"zip"];
    
    // 创建一个文件管理器
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [docPath objectAtIndex:0];
    NSString * copyPath = [NSString stringWithFormat:@"%@/defTheme.zip",documentsPath];
    
    if([manager fileExistsAtPath:copyPath]){
        
        NSLog(@"默认主题已经存在");
        return;
        
    }
    
    
    //
    NSError * err;
    BOOL isCopy = [manager copyItemAtPath:defThemePath toPath:copyPath error:&err];
    
    if (isCopy) {
        
        //解压
        ZipArchive* zipFile = [[ZipArchive alloc] init];
        [zipFile UnzipOpenFile:copyPath];
        NSString *unzipPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"theme"];
        [zipFile UnzipFileTo:unzipPath overWrite:true];
        [zipFile UnzipCloseFile];
        
        [[NSUserDefaults standardUserDefaults]setValue:@"defTheme"  forKey:@"themeName"];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotificationName:THEME_POST object:nil];
        
    } else {
        NSLog(@"拷贝失败");
    }
    
}



+ (UIColor *)colorForKey:(NSString *)key {
    return [[SkinSettingManager sharedManager] ColorDic][key]?:[UIColor clearColor];;
}

+ (UIColor *)themeColor {
    return [SkinSettingManager colorForKey:@"theme"];
}

+ (UIColor *)controllerBgColor {
    return [SkinSettingManager colorForKey:@"controllerBg"];
}

+ (UIColor *)fontColor {
    return [SkinSettingManager colorForKey:@"fontColor"];
}


@end
