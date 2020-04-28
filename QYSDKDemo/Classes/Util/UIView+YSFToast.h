/***************************************************************************
 
UIView+Toast.h
Toast

Copyright (c) 2014 Charles Scalesse.
 
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
***************************************************************************/

#import <UIKit/UIKit.h>

extern NSString * const YSFToastPositionTop;
extern NSString * const YSFToastPositionCenter;
extern NSString * const YSFToastPositionBottom;

@interface UIView (YSFToast)

// each makeToast method creates a view and displays it as toast
- (void)ysf_makeToast:(NSString *)message;
- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)ysf_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner
- (void)ysf_makeToastActivity;
- (void)ysf_makeToastActivity:(id)position;
- (void)ysf_hideToastActivity;

// the showToast methods display any view as toast
- (void)ysf_showToast:(UIView *)toast;
- (void)ysf_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)ysf_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point
      tapCallback:(void(^)(void))tapCallback;

//loading/load success/load fail
- (void)ysf_makeActivityToast:(NSString *)toast shadow:(BOOL)shadow;
- (void)ysf_makeToast:(NSString *)toast image:(UIImage *)image shadow:(BOOL)shadow duration:(NSTimeInterval)interval;

@end
