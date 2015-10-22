//
//  AppDelegate.m
//  Business Time
//
//  Created by Randall Dailey on 10/21/15.
//  Copyright © 2015 Randall Dailey. All rights reserved.
//

#import "AppDelegate.h"
#import "Localytics.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Localytics autoIntegrate:@"9a44a9af2db80438ea3d0d4-58f53f5a-782e-11e5-c388-0013a62af900" launchOptions:launchOptions];
    [Localytics setLoggingEnabled:YES];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge)];
    }
    
    
    return YES;
}

@end
