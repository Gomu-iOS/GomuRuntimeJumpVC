//
//  AppDelegate.m
//  GomuRuntimeJumpVC
//
//  Created by 庞彬 on 2018/9/3.
//  Copyright © 2018年 Gomu. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //延时
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self test];
    });
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)test
{
    //这个规则和服务器沟通好，跳转参数，跳转界面之类的东西
    NSDictionary *userInfo = @{
                               @"class": @"TestViewController",
                               @"property": @{
                                       @"ID": @"123",
                                       @"type": @"12"
                                       }
                               };
    
    [self push:userInfo];
}

/**
 *  跳转界面
 */
- (void)push:(NSDictionary *)params{
    //类名
    NSString *class = [NSString stringWithFormat:@"%@",params[@"class"]];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    Class newClass = objc_getClass(className);
    
    if (!newClass) {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    //创建对象
    id jumpVc = [[newClass alloc] init];
    
    NSDictionary *propertys = params[@"property"];
    [propertys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 检测这个对象是否存在该属性
        if ([self checkIsExistPropertyWithInstance:jumpVc verifyPropertyName:key]) {
            // 利用kvc赋值
            [jumpVc setValue:obj forKey:key];
        }
    }];
    
    // 获取导航控制器
    UITabBarController *tabVC = (UITabBarController *)self.window.rootViewController;
    UINavigationController *pushClassStance = (UINavigationController *)tabVC.viewControllers[tabVC.selectedIndex];
    
    // 跳转到对应的控制器
    [pushClassStance pushViewController:jumpVc animated:YES];
}

/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    return NO;
}

@end










