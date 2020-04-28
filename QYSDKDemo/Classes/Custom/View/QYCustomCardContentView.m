//
//  QYCustomCardContentView.m
//  YSFDemo
//
//  Created by liaosipei on 2018/11/29.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "QYCustomCardContentView.h"
#import "QYCustomCardModel.h"
#import "QYCustomCardMessage.h"
#import <QYSDK/QYCustomSDK.h>

NSString * const QYCustomEventTapDeleteButton = @"QYCustomEventTapDeleteButton";
static NSString * const QYCustomCardReuseIdentifier = @"QYCustomCardReuseIdentifier";


@interface QYCustomCardContentView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) UICollectionView *collection;

@end

@implementation QYCustomCardContentView
- (instancetype)initCustomContentView {
    self = [super initCustomContentView];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _itemArray = [NSMutableArray array];
        [_itemArray addObject:[[UIColor redColor] colorWithAlphaComponent:0.4]];
        [_itemArray addObject:[[UIColor blueColor] colorWithAlphaComponent:0.4]];
        [_itemArray addObject:[[UIColor yellowColor] colorWithAlphaComponent:0.4]];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(150, 180);
        layout.minimumInteritemSpacing = 20;
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor clearColor];
        _collection.scrollEnabled = YES;
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.showsHorizontalScrollIndicator = NO;
        [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:QYCustomCardReuseIdentifier];
        [self addSubview:_collection];
    }
    return self;
}

- (void)refreshData:(QYCustomModel *)model {
    [super refreshData:model];
    if (![model isKindOfClass:[QYCustomCardModel class]]) {
        return;
    }
    _collection.frame = self.bounds;
    [_collection scrollsToTop];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _collection.frame = self.bounds;
    [_collection scrollsToTop];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QYCustomCardReuseIdentifier forIndexPath:indexPath];
    NSInteger itemIndex = indexPath.item;
    id obj = [_itemArray objectAtIndex:itemIndex];
    if (obj && [obj isKindOfClass:[UIColor class]]) {
        cell.backgroundColor = (UIColor *)obj;
    }
    if (itemIndex == _itemArray.count - 1) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tintColor = [UIColor whiteColor];
        [button setTitle:@"删除" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        button.bounds = CGRectMake(0, 0, 80, 40);
        button.center = cell.contentView.center;
        button.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - action
- (void)onTapButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCatchEvent:)]) {
        QYCustomEvent *event = [[QYCustomEvent alloc] init];
        event.eventName = QYCustomEventTapDeleteButton;
        event.message = self.model.message;
        [self.delegate onCatchEvent:event];
    }
}

@end
