//
//  IDmeDraggableLabel.m
//  IDmeDraggableLabel
//
//  Created by Arthur Sabintsev on 2/11/14.
//  Copyright (c) 2014 ID.me, Inc. All rights reserved.
//

#import "IDmeDraggableLabel.h"
#import "IDmeDraggableLabelModel.h"

@interface IDmeDraggableLabel ()

@end

@implementation IDmeDraggableLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _initialFrame = frame;
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	CGPoint previousLocation = [touch previousLocationInView:touch.view];
	CGPoint location = [touch locationInView:touch.view];
	CGFloat deltaX = location.x - previousLocation.x;
	CGFloat deltaY = location.y - previousLocation.y;
    CGFloat newLocationX = touch.view.center.x + deltaX;
    CGFloat newLocationY = touch.view.center.y + deltaY;
	touch.view.center = CGPointMake(newLocationX, newLocationY);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *dataSource = [[IDmeDraggableLabelModel sharedInstance] dataSource];
    NSString *draggableLabelText = [[IDmeDraggableLabelModel sharedInstance] draggableLabelText];
    UIWebView *webView = [[IDmeDraggableLabelModel sharedInstance] webView];

    CGPoint location = CGPointMake(self.frame.origin.x, self.frame.origin.y - 44.0f);
    for (NSUInteger i = 0; i < [dataSource count]; ++i) {
        NSValue *frameValue = (NSValue *)[dataSource objectAtIndex:i];
        CGRect inputFrame = [frameValue CGRectValue];
        BOOL xCondition = (location.x >= inputFrame.origin.x && location.x <= inputFrame.origin.x + inputFrame.size.width);
        BOOL yCondition = (location.y >= inputFrame.origin.y && location.y <= inputFrame.origin.y + inputFrame.size.height);
        
        
        BOOL zeroCondition = CGRectEqualToRect(inputFrame, CGRectZero);
        if (xCondition && yCondition && !zeroCondition) {
            NSString *form = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%@].value = '%@'", @(i), draggableLabelText];
            [webView stringByEvaluatingJavaScriptFromString:form];
        }
    }
    
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = [self initialFrame];
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.frame = [self initialFrame];
}

@end
