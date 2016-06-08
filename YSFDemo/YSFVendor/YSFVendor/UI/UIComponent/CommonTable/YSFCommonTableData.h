//
//  YSFCommonTableData.h
//  NIM
//
//  Created by chris on 15/6/26.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define YSFSepLineLeft 15 //分割线距左边距离

//section key
#define YSFHeaderTitle  @"headerTitle"
#define YSFFooterTitle  @"footerTitle"
#define YSFHeaderHeight @"headerHeight"
#define YSFFooterHeight @"footerHeight"
#define YSFRowContent   @"row"

//row key
#define YSFTitle         @"title"
#define YSFDetailTitle   @"detailTitle"
#define YSFCellClass     @"cellClass"
#define YSFCellAction    @"action"
#define YSFExtraInfo     @"extraInfo"
#define YSFRowHeight     @"rowHeight"
#define YSFSepLeftEdge   @"leftEdge"


//common key
#define YSFDisable       @"disable"      //cell不可见
#define YSFShowAccessory @"accessory"    //cell显示>箭头
#define YSFForbidSelect  @"forbidSelect" //cell不响应select事件

@interface YSFCommonTableSection : NSObject

@property (nonatomic,copy)   NSString *headerTitle;

@property (nonatomic,copy)   NSArray *rows;

@property (nonatomic,copy)   NSString *footerTitle;

@property (nonatomic,assign) CGFloat  uiHeaderHeight;

@property (nonatomic,assign) CGFloat  uiFooterHeight;

- (instancetype) initWithDict:(NSDictionary *)dict;

+ (NSArray *)sectionsWithData:(NSArray *)data;

@end




@interface YSFCommonTableRow : NSObject

@property (nonatomic,strong) NSString *title;

@property (nonatomic,copy  ) NSString *detailTitle;

@property (nonatomic,copy  ) NSString *cellClassName;

@property (nonatomic,copy  ) NSString *cellActionName;

@property (nonatomic,assign) CGFloat  uiRowHeight;

@property (nonatomic,assign) CGFloat  sepLeftEdge;

@property (nonatomic,assign) BOOL     showAccessory;

@property (nonatomic,assign) BOOL     forbidSelect;

@property (nonatomic,strong) id extraInfo;

- (instancetype) initWithDict:(NSDictionary *)dict;

+ (NSArray *)rowsWithData:(NSArray *)data;

@end




