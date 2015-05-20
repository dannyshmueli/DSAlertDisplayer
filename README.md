# DSAlertDisplayer

###Why
* In iOS8 new [UIAlertController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIAlertController_class/) was introduced to replace UIAlertView.
* In iOS8.3 using the UIAlertView caused a crash, see [Stack Overflow 1](http://stackoverflow.com/questions/29534105/uialertview-crashs-in-ios-8-3), [Stack Overflow 2](http://stackoverflow.com/questions/29629106/ios-8-3-supported-orientations-crashs).

Since some of the apps still support iOS7 I've created a helper that supports most of the common uses of UIAlertView and translate them to UIAlertController. And also moving the alerts to blocks is much nicer.

###Usage:
```Objc
#import "DSAlertDisplayer.h"
```

```ObjC
  DSAlertAction *alertAction1 = [DSAlertAction actionWithTitle:@"Action 1"
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(DSAlertAction *action){
                                                          NSLog(@"pressed action 1");
                                                       }];
    
  [DSAlertDisplayer displayAlertWithTitle:@"Title"
                                  message:@"Message"
                             alertActions:@[alertAction1]
                 presentingViewController:nil];
```

###Install
* Copy the `DSAlertDisplayer.h`, `DSAlertDisplayer.m` to your project.

Or
* As git submodule:
```
git submodule add https://github.com/dannyshmueli/DSAlertDisplayer.git
```
