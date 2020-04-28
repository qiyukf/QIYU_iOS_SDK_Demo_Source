//
//  UIControl+YSFBlocksKit.m
//  BlocksKit
//

#import "UIControl+YSFBlocksKit.h"
@import ObjectiveC.runtime;

static const void *YSFControlHandlersKey = &YSFControlHandlersKey;

#pragma mark Private

@interface YSFControlWrapper : NSObject <NSCopying>

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation YSFControlWrapper

- (id)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
	self = [super init];
	if (!self) return nil;

	self.handler = handler;
	self.controlEvents = controlEvents;

	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[YSFControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender
{
	self.handler(sender);
}

@end

#pragma mark Category

@implementation UIControl (YSFBlocksKit)

- (void)ysf_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents
{
	NSParameterAssert(handler);
	
	NSMutableDictionary *events = objc_getAssociatedObject(self, YSFControlHandlersKey);
	if (!events) {
		events = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, YSFControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	NSNumber *key = @(controlEvents);
	NSMutableSet *handlers = events[key];
	if (!handlers) {
		handlers = [NSMutableSet set];
		events[key] = handlers;
	}
	
	YSFControlWrapper *target = [[YSFControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
	[handlers addObject:target];
	[self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)ysf_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
	NSMutableDictionary *events = objc_getAssociatedObject(self, YSFControlHandlersKey);
	if (!events) {
		events = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, YSFControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	NSNumber *key = @(controlEvents);
	NSSet *handlers = events[key];

	if (!handlers)
		return;

	[handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
		[self removeTarget:sender action:NULL forControlEvents:controlEvents];
	}];

	[events removeObjectForKey:key];
}

- (BOOL)ysf_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents
{
	NSMutableDictionary *events = objc_getAssociatedObject(self, YSFControlHandlersKey);
	if (!events) {
		events = [NSMutableDictionary dictionary];
		objc_setAssociatedObject(self, YSFControlHandlersKey, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	NSNumber *key = @(controlEvents);
	NSSet *handlers = events[key];
	
	if (!handlers)
		return NO;
	
	return !!handlers.count;
}

@end
