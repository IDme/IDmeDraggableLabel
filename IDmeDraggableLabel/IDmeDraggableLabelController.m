//
//  IDmeDraggableLabelController.m
//  IDmeDraggableLabel
//
//  Created by Arthur Sabintsev on 2/11/14.
//  Copyright (c) 2014 ID.me, Inc. All rights reserved.
//

#import "IDmeDraggableLabelController.h"
#import "IDmeDraggableLabelModel.h"
#import "IDmeDraggableLabel.h"

@interface IDmeDraggableLabelController () <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IDmeDraggableLabel *label;
@property (nonatomic, copy) NSString *website;

@end

@implementation IDmeDraggableLabelController

#pragma mark - Initialiation
- (instancetype)initWithDraggableLabelText:(NSString *)draggableLabelText
                                forWebsite:(NSString *)website
{
    self = [super init];
    if (self) {
        _website = website;
        [[IDmeDraggableLabelModel sharedInstance] setDraggableLabelText:draggableLabelText];
        [[IDmeDraggableLabelModel sharedInstance] setDataSource:[@[] mutableCopy]];
    }
    
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSubviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self cleanup];
}

#pragma mark - View Creation
- (void)createSubviews
{
    // webView
    CGRect windowFrame = [[[UIApplication sharedApplication] delegate] window].frame;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:windowFrame];
    webView.delegate = self;
    webView.scrollView.delegate = self;
    NSURL *webURL = [NSURL URLWithString:[self website]];
    [webView loadRequest:[NSURLRequest requestWithURL:webURL]];
    [self.view addSubview:webView];
    [[IDmeDraggableLabelModel sharedInstance] setWebView:webView];
    
    // label
    self.label = [[IDmeDraggableLabel alloc] initWithFrame:CGRectZero];
    self.label.backgroundColor = [UIColor lightGrayColor];
    self.label.userInteractionEnabled = YES;
    [self.label setText:[[IDmeDraggableLabelModel sharedInstance] draggableLabelText]];
    [self.label sizeToFit];
    self.label.center = CGPointMake(self.navigationController.navigationBar.frame.size.width/2.0f, self.navigationController.navigationBar.frame.size.height/2.0f);
    self.navigationItem.titleView = [self label];
    self.label.initialFrame = self.label.frame;
}

#pragma mark - Actions
- (void)findAllInputFields
{
    UIWebView *webView = [[IDmeDraggableLabelModel sharedInstance] webView];
    NSString *inputCountString = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('input').length"];
    for (NSUInteger i = 0; i < [inputCountString intValue]; ++i) {
        NSString *left = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%@].getBoundingClientRect().left", @(i)];
        NSString *top = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%@].getBoundingClientRect().top", @(i)];
        NSString *width = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%@].getBoundingClientRect().width", @(i)];
        NSString *height = [NSString stringWithFormat:@"document.getElementsByTagName('input')[%@].getBoundingClientRect().height", @(i)];
        
        NSString *leftExtractor = [webView stringByEvaluatingJavaScriptFromString:left];
        NSString *topEtractor = [webView stringByEvaluatingJavaScriptFromString:top];
        NSString *widthExtractor = [webView stringByEvaluatingJavaScriptFromString:width];
        NSString *heightExtractor = [webView stringByEvaluatingJavaScriptFromString:height];
        
        CGRect inputFrame =  CGRectMake([leftExtractor floatValue],
                                        [topEtractor floatValue],
                                        [widthExtractor floatValue],
                                        [heightExtractor floatValue]);
        
        NSValue *inputValue = [NSValue valueWithCGRect:inputFrame];
        [[IDmeDraggableLabelModel sharedInstance].dataSource addObject:inputValue];
    }
}

#pragma mark - Cleanup
- (void)cleanup
{
    [self destroyWebView];
    [[IDmeDraggableLabelModel sharedInstance] clearDraggableLabelText];
}

- (void)destroyWebView
{
    UIWebView *webView = [[IDmeDraggableLabelModel sharedInstance] webView];
    if ([[IDmeDraggableLabelModel sharedInstance] webView]) {
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
        
        NSHTTPCookie *cookie;
        for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        
        [webView loadHTMLString:@"" baseURL:nil];
        [webView stopLoading];
        [webView setDelegate:nil];
        [webView.scrollView setDelegate:nil];
        [webView removeFromSuperview];
        webView = nil;
    }
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self findAllInputFields];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[IDmeDraggableLabelModel sharedInstance].dataSource removeAllObjects];
    [[IDmeDraggableLabelModel sharedInstance] setDataSource:[@[] mutableCopy]];
    [self findAllInputFields];
}

@end
