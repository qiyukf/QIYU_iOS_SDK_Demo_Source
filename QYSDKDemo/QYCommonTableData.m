//
//  QYCommonTableData.m
//  QYSDKDemo
//
//  Created by liaosipei on 2020/3/2.
//  Copyright © 2020 Netease. All rights reserved.
//

#import "QYCommonTableData.h"


@implementation QYCommonRowData

- (instancetype)initWithDict:(NSDictionary *)dict{
    if ([dict[QYDisable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _type = [dict[QYType] integerValue];
        _title = dict[QYTitle];
        _detailTitle = dict[QYDetailTitle];
        _showAccessory = [dict[QYShowAccessory] boolValue];
        _extraInfo = dict[QYExtraInfo];
    }
    return self;
}

+ (NSArray *)rowsWithData:(NSArray *)data {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            QYCommonRowData *row = [[QYCommonRowData alloc] initWithDict:dict];
            if (row) {
                [array addObject:row];
            }
        }
    }
    return array;
}

@end


@implementation QYCommonSectionData

- (instancetype)initWithDict:(NSDictionary *)dict {
    if ([dict[QYDisable] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _headerTitle = dict[QYHeaderTitle];
        _footerTitle = dict[QYFooterTitle];
        _rows = [QYCommonRowData rowsWithData:dict[QYRowContent]];
    }
    return self;
}

+ (NSArray *)sectionsWithData:(NSArray *)data {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            QYCommonSectionData * section = [[QYCommonSectionData alloc] initWithDict:dict];
            if (section) {
                [array addObject:section];
            }
        }
    }
    return array;
}

@end
