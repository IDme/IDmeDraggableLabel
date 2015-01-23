//
//  IDmeDraggableLabel.m
//  IDmeDraggableLabel
//
//  Created by Arthur Sabintsev on 2/11/14.
//  Copyright (c) 2014 ID.me, Inc. All rights reserved.
//

#import "IDmeDraggableLabelModel.h"

@implementation IDmeDraggableLabelModel

#pragma mark - Initialization
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)clearDraggableLabelText
{
    self.draggableLabelText = nil;
    self.dataSource = nil;
    self.webView = nil;
}


@end
