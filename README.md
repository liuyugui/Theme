# Theme

## 使用步骤：

- 1、订阅通知

```
//订阅通知
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeThemeNotification:) name:THEME_POST object:nil];

```

- 2、实现订阅方法

`
//主题变更时处理的方法
- (void)changeThemeNotification:(NSNotification *)notofacetion{
    //这里是主题改变时
}

`

- 3、复制默认主题

`
//复制默认主题
[SkinSettingManager copyDefTheme];

`

- 4、如果需要从网上下载主题的话

`
//下载主题
[SkinSettingManager downLoadThemeWithUrlStr:fileUrl];

`
## 主题包

`
{
    "colors": {
        "theme":"#ff0000",
        "controllerBg":"#787878",
        "fontColor":"#00ff00"
    },
    "images": {
        "phone":"phone.png",
        "email":"email.png"
    }
}

`
