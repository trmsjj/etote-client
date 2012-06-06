//
//  CheckoutViewController.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface CheckoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *thankyouLabel;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *gradientView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextArea;
@end
