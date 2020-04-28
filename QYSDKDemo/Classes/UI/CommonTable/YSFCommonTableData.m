//
//  YSFCommonTableData.m
//  NIM
//
//  Created by chris on 15/6/26.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "YSFCommonTableData.h"
#import <UIKit/UIKit.h>

#define YSFDefaultUIRowHeight  44.f
#define YSFDefaultUIHeaderHeight  25.f
#define YSFDefaultUIFooterHeight  25.f

@implementation YSFCommonTableSection

- (instancetype) initWithDict:(NSDictionary *)dict{
    if ([dict[YSFDisable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _headerTitle = dict[YSFHeaderTitle];
        _footerTitle = dict[YSFFooterTitle];
        _uiFooterHeight = [dict[YSFFooterHeight] floatValue];
        _uiHeaderHeight = [dict[YSFHeaderHeight] floatValue];
        _uiHeaderHeight = _uiHeaderHeight ? _uiHeaderHeight : YSFDefaultUIHeaderHeight;
        _uiFooterHeight = _uiFooterHeight ? _uiFooterHeight : YSFDefaultUIFooterHeight;
        _rows = [YSFCommonTableRow rowsWithData:dict[YSFRowContent]];
    }
    return self;
}

+ (NSArray *)sectionsWithData:(NSArray *)data{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            YSFCommonTableSection * section = [[YSFCommonTableSection alloc] initWithDict:dict];
            if (section) {
                [array addObject:section];
            }
        }
    }
    return array;
}


@end



@implementation YSFCommonTableRow

- (instancetype) initWithDict:(NSDictionary *)dict{
    if ([dict[YSFDisable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        id obj = dict[YSFStyle];
        if (obj) {
            _style = [dict[YSFStyle] integerValue];
        } else {
            _style = YSFCommonCellStyleNormal;
        }
        
        _title = dict[YSFTitle];
        if (_title.length) {
            NSDictionary *dict = @{ NSFontAttributeName : [UIFont systemFontOfSize:17.0] };
            CGFloat textWidth = [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:dict
                                                     context:nil].size.width + 2;
            _titleWidth = MIN(275, roundf(textWidth));
        }
        
        _type = [dict[YSFType] integerValue];
        _result = dict[YSFResult];
        _switchOn = [dict[YSFSwitchOn] boolValue];
        _detailTitle = dict[YSFDetailTitle];
        _cellClassName = dict[YSFCellClass];
        _cellActionName = dict[YSFCellAction];
        _uiRowHeight = dict[YSFRowHeight] ? [dict[YSFRowHeight] floatValue] : YSFDefaultUIRowHeight;
        _extraInfo = dict[YSFExtraInfo];
        _sepLeftEdge = [dict[YSFSepLeftEdge] floatValue];
        _showAccessory = [dict[YSFShowAccessory] boolValue];
        _forbidSelect = [dict[YSFForbidSelect] boolValue];
        _badge = dict[YSFBadge];
    }
    return self;
}

+ (NSArray *)rowsWithData:(NSArray *)data{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            YSFCommonTableRow * row = [[YSFCommonTableRow alloc] initWithDict:dict];
            if (row) {
                [array addObject:row];
            }
        }
    }
    return array;
}


@end
