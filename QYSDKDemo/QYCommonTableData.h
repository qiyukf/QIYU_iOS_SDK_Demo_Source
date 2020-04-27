//
//  QYCommonTableData.h
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//section key
#define QYHeaderTitle  @"headerTitle"
#define QYFooterTitle  @"footerTitle"
#define QYRowContent   @"row"

//row key
#define QYType          @"type"
#define QYTitle         @"title"
#define QYDetailTitle   @"detailTitle"
#define QYExtraInfo     @"extraInfo"

//common key
#define QYDisable       @"disable"      //cell不可见
#define QYShowAccessory @"accessory"    //cell显示>箭头


@interface QYCommonRowData : NSObject

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, assign) BOOL showAccessory;
@property (nonatomic, strong) id extraInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (NSArray *)rowsWithData:(NSArray *)data;

@end


@interface QYCommonSectionData : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, copy) NSArray *rows;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (NSArray *)sectionsWithData:(NSArray *)data;

@end


NS_ASSUME_NONNULL_END
