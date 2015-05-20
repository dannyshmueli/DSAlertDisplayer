//
//  DSAlertDisplayer.h
//  DSAlertDisplayerExample
//
//  Created by Danny Shmueli on 5/20/15.
//  Copyright (c) 2015 Omdan. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Object that mimics UIAlertAction
 */
@interface DSAlertAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^handler)(DSAlertAction *action);

//iOS 8 and above
@property (nonatomic, readwrite) UIAlertActionStyle style;

/**
 *  Create and return an action with the specified title and behavior.
 *
 *  @param title   see UIAlertController / UIAlertView docs
 *  @param style   see UIAlertController docs
 *  @param handler A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
 *
 *  @return A new custom alert action object.
 */
+(instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(DSAlertAction *action))handler;

@end

@interface DSAlertDisplayer : NSObject

/**
 *  Presents UIAlertController on iOS8 or UIAlertView on iOS7 and prior.
 *
 *  @param title                    see UIAlertController / UIAlertView docs
 *  @param message                  see UIAlertController / UIAlertView docs
 *  @param alertActions             NSArray of DSAlertAction objects
 *  @param presentingViewController the view controller from which the alert is presented. If nil will use the top most view controller.
 */
+(void)displayAlertWithTitle:(NSString *)title
                     message:(NSString *)message
                alertActions:(NSArray *)alertActions
    presentingViewController:(UIViewController *)presentingViewController;

+(void)displayAlertWithTitle:(NSString *)title
                     message:(NSString *)message
                alertActions:(NSArray *)alertActions
    presentingViewController:(UIViewController *)presentingViewController
           cancelButtonIndex:(NSInteger)cancelButtonIndex NS_DEPRECATED_IOS(2_0, 7_1);
@end
