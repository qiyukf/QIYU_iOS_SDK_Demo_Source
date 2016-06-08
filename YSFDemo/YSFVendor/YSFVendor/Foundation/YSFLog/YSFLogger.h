//
//  YSFLogger.h
//  YSFVendor
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YSFLoggerLevelPro,
    YSFLoggerLevelApp,
    YSFLoggerLevelWar,
    YSFLoggerLevelErr,
} YSFLoggerLevel;

@interface YSFLogger : NSObject
+ (instancetype)sharedLogger;
@property (nonatomic,assign)    YSFLoggerLevel   level;
@property (nonatomic,copy)      NSString        *logDir;
@end


#define YSFLogErr(frmt, ...) YSFLOG_OBJC(YSFLoggerLevelPro, __FILE__, __LINE__,frmt,##__VA_ARGS__)
#define YSFLogWar(frmt, ...) YSFLOG_OBJC(YSFLoggerLevelApp, __FILE__, __LINE__,frmt,##__VA_ARGS__)
#define YSFLogApp(frmt, ...) YSFLOG_OBJC(YSFLoggerLevelWar, __FILE__, __LINE__,frmt,##__VA_ARGS__)
#define YSFLogPro(frmt, ...) YSFLOG_OBJC(YSFLoggerLevelErr, __FILE__, __LINE__,frmt,##__VA_ARGS__)

void YSFLOG_OBJC(YSFLoggerLevel level, const char *file, NSInteger line, NSString *format, ...);