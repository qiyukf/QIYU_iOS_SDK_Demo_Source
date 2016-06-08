//
//  YSFTimer.h
//
//  Created by yg on 11/11/15.
//  Copyright (c) 2015 yg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YSFTimerBlock)();

@interface YSFTimer : NSObject

/**
 *  开始定时
 *
 *  @param queue 定时任务执行所在的queue
 *  @param interval 时间间隔，以秒为单位
 *  @param repeats  是否重复
 *  @param cb  定时任务
 */
- (void)start:(dispatch_queue_t)queue interval:(NSInteger)interval repeats:(BOOL)repeats block:(YSFTimerBlock)block;

/**
 *  开始定时
 *
 *  @param startAfter 第一次执行时间，以秒为单位
 *  @param queue 定时任务执行所在的queue
 *  @param interval 时间间隔，以秒为单位
 *  @param repeats  是否重复
 *  @param cb  定时任务
 */
- (void)start:(dispatch_queue_t)queue startAfter:(NSInteger)startAfter interval:(NSInteger)interval
            repeats:(BOOL)repeats block:(YSFTimerBlock)block;

/**
 *  停止定时；YSFTimer析构时会自动调用，如果需要停止定时的时候YSFTimer会析构，则不需要手动调用stop
 */
- (void)stop;

@end

