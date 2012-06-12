//
//  AdminEditToteViewController.h
//  etote
//
//  Created by Ray Tiley on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tote.h"

@interface AdminEditToteViewController : UIViewController {
    Tote *tote;
}
@property (weak, nonatomic) IBOutlet UITextField *customerNameField;
@property (weak, nonatomic) IBOutlet UITextField *customerEmailField;
@property Tote *tote;
@property (weak, nonatomic) IBOutlet UITextView *customerCommentsField;
@property (weak, nonatomic) IBOutlet UITextView *salesPersonCommentsField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *syncedMessage;
@end
