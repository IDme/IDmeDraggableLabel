//
//  IDmeDraggableLabelModel.h
//  IDmeDraggableLabel
//
//  Created by Arthur Sabintsev on 2/11/14.
//  Copyright (c) 2014 ID.me, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface IDmeDraggableLabelModel : NSObject

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *draggableLabelText;

+ (instancetype)sharedInstance;
- (void)clearDraggableLabelText;

@end
