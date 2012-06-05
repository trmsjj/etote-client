//
//  SyncViewController.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncEngine.h"
#import "OBGradientView.h"

@interface SyncViewController : UIViewController <SyncEngineDelegate>
@property (weak, nonatomic) IBOutlet UILabel *toteStatusLabel;
@property (strong, nonatomic) IBOutlet OBGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UITextField *serverAddressField;
@property (weak, nonatomic) IBOutlet UITextField *ownerNameField;
@end
