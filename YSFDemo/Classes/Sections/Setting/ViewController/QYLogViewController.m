//
//  YSFLogViewController.m
//  YSFDemo
//
//  Created by amao on 15/9/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "QYLogViewController.h"
#import "UIView+YSFToast.h"

@interface QYLogViewController ()
@property (strong, nonatomic) IBOutlet UITextView *logTextView;
@property (copy,nonatomic) NSString *path;
@end

@implementation QYLogViewController


- (instancetype)initWithFilepath:(NSString *)path
{
    if (self = [self initWithNibName:@"QYLogViewController" bundle:nil])
    {
        self.path = path;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"复制" style:UIBarButtonItemStyleDone target:self action:@selector(onCopyLog:)];
    
    
    NSData *data = [NSData dataWithContentsOfFile:_path];
    NSString *content = [[NSString alloc] initWithData:data
                                              encoding:NSUTF8StringEncoding];
    if (content == nil)
    {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSASCIIStringEncoding];
    }
    _logTextView.text = content;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCopyLog:(id)sender
{
    [[UIPasteboard generalPasteboard] setString:_logTextView.text];
    
    [self.view ysf_makeToast:@"日志已复制"];
}



@end
