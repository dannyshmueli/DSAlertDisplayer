//
//  DSAlertDisplayer.m
//  DSAlertDisplayerExample
//
//  Created by Danny Shmueli on 5/20/15.
//  Copyright (c) 2015 Omdan. All rights reserved.
//

#import "DSAlertDisplayer.h"

@implementation DSAlertAction

+(instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(DSAlertAction *action))handler
{
    DSAlertAction *alertAction = [DSAlertAction new];
    alertAction.title = title;
    alertAction.handler = handler;
    alertAction.style = style;
    
    return alertAction;
}

-(UIAlertAction *)convertToUIAlertActionWithBeforeHandlerBlock:(void(^)())beforeHandlerBlock
{
    return [UIAlertAction actionWithTitle:self.title style:self.style handler:^(UIAlertAction *alertAction){
        beforeHandlerBlock();
        if (self.handler){
            self.handler(self);
        }
    }];
}

@end



@interface DSAlertDisplayer() <UIAlertViewDelegate>

//for iOS 7 we need to retain the actions
//remember to clear them as this is a singleton when not iOS8.
@property (nonatomic, strong) NSArray *alertActions;

@end

@implementation DSAlertDisplayer

#pragma mark - API

+(void)displayAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray *)alertActions presentingViewController:(UIViewController *)presentingViewController
{
    [self displayAlertWithTitle:title message:message alertActions:alertActions presentingViewController:presentingViewController cancelButtonIndex:NSNotFound];
}

+(void)displayAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray *)alertActions presentingViewController:(UIViewController *)presentingViewController cancelButtonIndex:(NSInteger)cancelButtonIndex
{
    if ([self isBeforeIOS8])
    {
        [self displayOldStyleAlertWithTitle:title message:message alertActions:alertActions cancelButtonIndex:cancelButtonIndex];
    }
    else
    {
        [self displayNewAlertWithTitle:title message:message alertActions:alertActions presentingViewController:presentingViewController];
    }
    
}

#pragma mark - Alert Openers

+(void)displayOldStyleAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray *)alertActions cancelButtonIndex:(NSInteger)cancelButtonIndex
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
    
    [[self sharedInstance] setAlertActions:alertActions];
    alertView.delegate = [self sharedInstance];
    for (DSAlertAction *action in alertActions)
    {
        [alertView addButtonWithTitle:action.title];
    }
    
    if (cancelButtonIndex != NSNotFound){
        alertView.cancelButtonIndex = cancelButtonIndex;
    }
    [alertView show];
}

+(void)displayNewAlertWithTitle:(NSString *)title message:(NSString *)message alertActions:(NSArray *)alertActions presentingViewController:(UIViewController *)presentingViewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (DSAlertAction *action in alertActions)
    {
        UIAlertAction *overwrittenAction = [action convertToUIAlertActionWithBeforeHandlerBlock:^
                                            {
                                                [alertController dismissViewControllerAnimated:YES completion:nil];
                                            }];
        [alertController addAction:overwrittenAction];
    }
    
    if (!presentingViewController)
    {
        presentingViewController =  [self topMostController];
    }
    [presentingViewController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DSAlertAction *action =  self.alertActions[buttonIndex];
    action.handler(action);

    //clearing the actions for saving memory
    self.alertActions = nil;
}

#pragma mark - Private

+(instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+(BOOL)isBeforeIOS8
{
    NSComparisonResult comparedToIOS7 = [[UIDevice currentDevice].systemVersion compare:@"7.1" options:NSNumericSearch];
    return comparedToIOS7 == NSOrderedAscending || comparedToIOS7 == NSOrderedSame;
}

+ (UIViewController*) topMostController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow)
    {
        keyWindow = [[[UIApplication sharedApplication] delegate] window];
    }
    UIViewController *topController = keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

@end
