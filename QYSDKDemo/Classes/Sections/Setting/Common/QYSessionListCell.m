//
//  YSFSessionListCell.m
//  YSFSDK
//
//  Created by JackyYu on 16/12/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "QYSessionListCell.h"
#import "QYBadgeView.h"
#import "UIView+YSF.h"
#import "QYAvatarImageView.h"
#import "QYMacro.h"
#import <QYSDK/QYPOPSDK.h>


#define kNameLabelMaxWidth      160.f


@interface QYSessionListCell ()

@property (nonatomic, strong) QYAvatarImageView *avatarImageView; //商铺头像
@property (nonatomic, strong) UILabel *sessionNameLabel;    //会话名称，可以是商铺名称
@property (nonatomic, strong) UILabel *messageLabel;        //最新消息文本
@property (nonatomic, strong) UILabel *sessionStatusLabel;    //会话状态
@property (nonatomic, strong) UILabel *timeLabel;           //最新消息时间戳
@property (nonatomic, strong) UIView *status;               //状态
@property (nonatomic, strong) QYBadgeView *badgeView;       //未读消息数View
@property (nonatomic, strong) UIView *seperatorLine;        //Cell间隔线

@end


@implementation QYSessionListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatMainView];
    }
    return self;
}

- (void)creatMainView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.avatarImageView = [[QYAvatarImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self addSubview:_avatarImageView];
    
    //敏感词失败图标
    _trashWordsFailedIcon = [[UIImageView alloc] init];
    _trashWordsFailedIcon.image = [UIImage imageNamed:@"icon_file_transfer_cancel"];
    [self addSubview:_trashWordsFailedIcon];

    self.sessionNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sessionNameLabel.backgroundColor = [UIColor whiteColor];
    _sessionNameLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:_sessionNameLabel];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLabel.backgroundColor = [UIColor whiteColor];
    _messageLabel.font = [UIFont systemFontOfSize:12.0f];
    _messageLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_messageLabel];

    self.status = [[UIView alloc] initWithFrame:CGRectZero];
    _status.ysf_frameWidth = 8;
    _status.ysf_frameHeight = 8;
    _status.layer.cornerRadius = 4;
    [self addSubview:_status];

    self.sessionStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sessionStatusLabel.backgroundColor = [UIColor whiteColor];
    _sessionStatusLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_sessionStatusLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.backgroundColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_timeLabel];
    
    self.badgeView = [QYBadgeView viewWithBadgeTip:@""];
    [self addSubview:_badgeView];
    
    self.seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(70, CGRectGetHeight(self.bounds), YSFUIScreenWidth - 70, 1.0/YSFUIScreenScale)];
    _seperatorLine.backgroundColor = YSFColorFromRGB(0xdde3e5);
    [self addSubview:_seperatorLine];
}

- (void)setSessionInfo:(QYSessionInfo *)sessionInfo {
    _sessionInfo = sessionInfo;
    _trashWordsFailedIcon.hidden = !sessionInfo.hasTrashWords;
}

- (void)layoutSubviews {
    _sessionNameLabel.text = _sessionInfo.sessionName;
    [_sessionNameLabel sizeToFit];

    _trashWordsFailedIcon.ysf_frameWidth = 18;
    _trashWordsFailedIcon.ysf_frameHeight = 18;
    _messageLabel.text = _sessionInfo.lastMessageText;
    [_messageLabel sizeToFit];
    
    if (_sessionInfo.status == QYSessionStatusInSession) {
        _status.backgroundColor = [UIColor greenColor];
        _sessionStatusLabel.text = @"会话中";
    } else if (_sessionInfo.status == QYSessionStatusWaiting) {
        _status.backgroundColor = [UIColor yellowColor];
        _sessionStatusLabel.text = @"排队中";
    } else {
        _status.backgroundColor = [UIColor clearColor];
        _sessionStatusLabel.text = @"";
    }
    [_sessionStatusLabel sizeToFit];
    
    _timeLabel.text = [self showTime:_sessionInfo.lastMessageTimeStamp showDetail:YES];
    [_timeLabel sizeToFit];
    
    self.sessionNameLabel.ysf_frameWidth = self.sessionNameLabel.ysf_frameWidth > kNameLabelMaxWidth ? kNameLabelMaxWidth : self.sessionNameLabel.ysf_frameWidth;
    self.messageLabel.ysf_frameWidth = self.ysf_frameWidth - 170;
    
    if (_sessionInfo.unreadCount) {
        _badgeView.hidden = NO;
        if (_sessionInfo.unreadCount > 99) {
            _badgeView.badgeValue = @"99+";
        } else {
            _badgeView.badgeValue = @(_sessionInfo.unreadCount).stringValue;
        }
    } else {
        _badgeView.hidden = YES;
    }
    
    if (_sessionInfo.avatarImageUrlString) {
        [_avatarImageView qy_setImageWithURL:[NSURL URLWithString:_sessionInfo.avatarImageUrlString]
                            placeholderImage:[UIImage imageNamed:@"icon_service_avatar"]
                                     options:SDWebImageRetryFailed];
    } else {
        _avatarImageView.image = [UIImage imageNamed:@"icon_service_avatar"];
    }
    _avatarImageView.ysf_frameLeft = 15;
    _avatarImageView.ysf_frameCenterY = self.ysf_frameHeight * 0.5;
    
    _sessionNameLabel.ysf_frameTop = 15;
    _sessionNameLabel.ysf_frameLeft = _avatarImageView.ysf_frameRight + 15;
    _sessionNameLabel.ysf_frameWidth = self.ysf_frameWidth - 150;
    
    _trashWordsFailedIcon.ysf_frameLeft = _avatarImageView.ysf_frameRight + 15;
    _trashWordsFailedIcon.ysf_frameBottom = self.ysf_frameHeight - 15;
    
    if (!_trashWordsFailedIcon.hidden) {
        _messageLabel.ysf_frameLeft = _trashWordsFailedIcon.ysf_frameRight + 5;
    } else {
        _messageLabel.ysf_frameLeft = _avatarImageView.ysf_frameRight + 15;
    }
    _messageLabel.ysf_frameBottom = self.ysf_frameHeight - 15;
    
    _timeLabel.ysf_frameRight = self.ysf_frameWidth - 15;
    _timeLabel.ysf_frameTop = 15;
    
    _status.ysf_frameRight = self.ysf_frameWidth - 87;
    _status.ysf_frameBottom = self.ysf_frameHeight - 18;
    
    _sessionStatusLabel.ysf_frameRight = self.ysf_frameWidth - 45;
    _sessionStatusLabel.ysf_frameBottom = self.ysf_frameHeight - 15;
    
    _badgeView.ysf_frameRight = self.ysf_frameWidth - 15;
    _badgeView.ysf_frameBottom = self.ysf_frameHeight - 15;
    _seperatorLine.ysf_frameTop = self.ysf_frameHeight - _seperatorLine.ysf_frameHeight;
}

- (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail {
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    NSDate *today = [[NSDate alloc] init];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSDateComponents *yesterdayDateComponents = [[NSCalendar currentCalendar] components:components fromDate:yesterday];
    
    NSInteger hour = msgDateComponents.hour;
    result = @"";
    
    if(nowDateComponents.year == msgDateComponents.year
       && nowDateComponents.month == msgDateComponents.month
       && nowDateComponents.day == msgDateComponents.day) {
        //今天,hh:mm
        result = [[NSString alloc] initWithFormat:@"%@ %ld:%02d",result,(long)hour,(int)msgDateComponents.minute];
    } else if(yesterdayDateComponents.year == msgDateComponents.year
            && yesterdayDateComponents.month == msgDateComponents.month
            && yesterdayDateComponents.day == msgDateComponents.day) {
        //昨天，昨天 hh:mm
        result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %ld:%02d",result,(long)hour,(int)msgDateComponents.minute] : @"昨天";
    } else if(nowDateComponents.year == msgDateComponents.year) {
        //今年，MM/dd hh:mm
        result = [NSString stringWithFormat:@"%02d/%02d %ld:%02d",(int)msgDateComponents.month,(int)msgDateComponents.day,(long)msgDateComponents.hour,(int)msgDateComponents.minute];
    } else if((nowDateComponents.year != msgDateComponents.year)) {
        //跨年， YY/MM/dd hh:mm
        NSString *day = [NSString stringWithFormat:@"%02d/%02d/%02d", (int)(msgDateComponents.year%100), (int)msgDateComponents.month, (int)msgDateComponents.day];
        result = showDetail? [day stringByAppendingFormat:@" %@ %ld:%02d",result,(long)hour,(int)msgDateComponents.minute]:day;
    }
    return result;
}

@end
