//
//  HomeViewController.h
//  etote
//
//  Created by Ray Tiley on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBGradientView.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet OBGradientView *gradientView;

@property (weak, nonatomic) IBOutlet UILabel *welcomeTextLabel;
@end
