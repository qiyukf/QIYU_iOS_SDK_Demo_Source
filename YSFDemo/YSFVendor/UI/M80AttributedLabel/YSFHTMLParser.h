//
//  HTMLParser.h
//  yixin_iphone
//
//  Created by Xuhui on 15/1/11.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFHTMLTagElement : NSObject

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, assign) NSRange effectRange;
@property(nonatomic, readonly) NSDictionary *attributes;

- (instancetype)initWithName:(NSString *)name attributes:(NSDictionary *)attributes effectRange:(NSRange)range;

@end

@interface YSFHTMLDocument : NSObject

@property (nonatomic, copy) NSString *plainText;
@property (nonatomic, readonly) NSArray *tagElements;

- (void)addTagElement:(YSFHTMLTagElement *)element;

@end

@protocol YSFHTMLParserProtocol <NSObject>

- (YSFHTMLDocument *)parse:(NSString *)htmlString;

@end

@interface YSFSimpleHTMLParser : NSObject <YSFHTMLParserProtocol>


@end
