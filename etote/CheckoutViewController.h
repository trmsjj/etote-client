//
//  CheckoutViewController.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

@interface CheckoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet OBGradientView *gradientView;

@property (weak, nonatomic) IBOutlet UILabel *thankyouLabel;
@end
