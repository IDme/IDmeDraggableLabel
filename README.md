# IDmeDraggableLabel
A proof-of-concept on how to drag a UILabel object into a UIWebView input/text field

## Background
This small library, developed in early 2014, allows you to drag a UILabel to any web input/text field. Upon doing so, the text in the UILabel is transferred to the input/text field in the webview.

This is a proof of concept. The code isn't clean nor is it documented. It's offered *as-is* to anyone who 

### Installation Instructions

#### CocoaPods Installation
```
pod 'IDmeDraggableLabel'
```

#### Manual Installation
Copy the `IDmeSegmentedControl` folder into your project. 

## Code Snippet

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    IDmeDraggableLabelController *draggableLabelController = [[IDmeDraggableLabelController alloc] initWithDraggableLabelText:@"Drag this Label" forWebsite:@"http://www.google.com/"];
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:draggableLabelController];
    [_window setRootViewController:controller];
    
    [_window makeKeyAndVisible];
   
    return YES;
}
```

## Created and maintained by
[Arthur Ariel Sabintsev](http://www.sabintsev.com)