//
//  NotificationService.h
//  ZYNotificationService
//
//  Created by asd on 2018/5/29.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>

@interface NotificationService : UNNotificationServiceExtension

@end
#endif
