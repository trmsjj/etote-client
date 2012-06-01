//
//  CheckoutViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "ToteStore.h"
#import "Tote.h"
#import "Document.h"

@implementation CheckoutViewController
@synthesize nameField;
@synthesize emailField;

- (IBAction)saveButtonSelected:(id)sender {
    [[self emailField] resignFirstResponder];
    [[self nameField] resignFirstResponder];
    //Save tote to store.
    
    Tote *newTote = [[ToteStore sharedStore] createTote];
    [newTote setName:[nameField text]];
    [newTote setEmail:[emailField text]];
    [newTote setDocumentIDs:[[NSMutableArray alloc] init]];
    
    //Loop through categories and add document ids to tote
    NSArray *categories = [[CategoriesStore sharedStore] allCategories];
    for(int i=0; i < [categories count]; i++)
    {
        NSArray *documents =[[categories objectAtIndex:i] documents];
        for(int j=0; j < [documents count]; j++)
        {
            Document *document = [documents objectAtIndex:j];
            if([document inTote])
            {
                [[newTote documentIDs] addObject:[document documentID]];
            }
        }
    }
    
    [[CategoriesStore sharedStore] emptyTote];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tbi = [self tabBarItem];
        [tbi setTitle:@"Checkout"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setNameField:nil];
    [self setEmailField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    NSLog(@"Return key pressed");
    if(textField == self.nameField)
    {
        NSLog(@"Keyboard should change");
        [emailField becomeFirstResponder];
    }else {
        [emailField resignFirstResponder];
    }
    return YES;
}
@end
