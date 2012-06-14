//
//  AdminEditToteViewController.m
//  etote
//
//  Created by Ray Tiley on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdminEditToteViewController.h"

@interface AdminEditToteViewController ()

@end

@implementation AdminEditToteViewController
@synthesize customerNameField;
@synthesize customerEmailField;
@synthesize tote;
@synthesize customerCommentsField;
@synthesize salesPersonCommentsField;
@synthesize saveButton;
@synthesize syncedMessage;

- (IBAction)saveButtonSelected:(id)sender {
    [salesPersonCommentsField resignFirstResponder];
    [tote setNotes:[salesPersonCommentsField text]];
    [[ToteStore sharedStore] saveChanges];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self customerNameField] setText:tote.name];
    [[self customerNameField] setEnabled:NO];
    [[self customerEmailField] setText:tote.email];
    [[self customerEmailField] setEnabled:NO];
    [[self customerCommentsField] setText:tote.customerComments];
    [[self customerCommentsField] setEditable:NO];
    [[self salesPersonCommentsField] setText:tote.notes];
    if(tote.synced == YES)
    {
        [[self salesPersonCommentsField] setEditable:NO];
        [[self saveButton] setHidden:YES];
    }
    else {
        [[self syncedMessage] setHidden:YES];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setCustomerNameField:nil];
    [self setCustomerEmailField:nil];
    [self setCustomerCommentsField:nil];
    [self setSalesPersonCommentsField:nil];
    [self setSaveButton:nil];
    [self setSyncedMessage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
