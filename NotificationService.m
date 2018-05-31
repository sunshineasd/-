//
//  NotificationService.m
//  ZYNotificationService
//
//  Created by asd on 2018/5/29.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "NotificationService.h"
#import <AVFoundation/AVFAudio.h>
#import "JPushNotificationExtensionService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max

@interface NotificationService ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;
@property (nonatomic, strong) AVSpeechSynthesizer *aVSpeechSynthesizer;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
//    // Modify the notification content here...
    //self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
    
    NSString *content = self.bestAttemptContent.userInfo[@"message"];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
    
    utterance.voice =[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];

    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    
    [synth speakUtterance:utterance];
        
    self.contentHandler(self.bestAttemptContent);
}


- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
#endif
