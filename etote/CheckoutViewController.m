//
//  CheckoutViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CheckoutViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "ToteStore.h"
#import "Tote.h"
#import "Document.h"

@implementation CheckoutViewController
@synthesize nameField;
@synthesize emailField;
@synthesize gradientView;
@synthesize thankyouLabel;
@synthesize commentsTextArea;

- (IBAction)saveButtonSelected:(id)sender {
    [[self emailField] resignFirstResponder];
    [[self nameField] resignFirstResponder];
    [[self commentsTextArea] resignFirstResponder];
    //Save tote to store.
    
    Tote *newTote = [[ToteStore sharedStore] createTote];
    [newTote setName:[nameField text]];
    [newTote setEmail:[emailField text]];
    [newTote setCustomerComments:[commentsTextArea text]];
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
    [thankyouLabel setHidden:NO];
    [[CategoriesStore sharedStore] emptyTote];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

- (void)timerFired:(NSTimer *)theTimer
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
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
    [thankyouLabel setHidden:YES];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor blackColor], nil];
    [[self gradientView] setColors:colors];
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setNameField:nil];
    [self setEmailField:nil];
    [self setThankyouLabel:nil];
    [self setGradientView:nil];
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
        [emailField becomeFirstResponder];
    }else if (textField == self.emailField) {
        [commentsTextArea becomeFirstResponder];
    }else {
        [commentsTextArea resignFirstResponder];
    }
    return NO;
}

- (BOOL)textViewShouldReturn:(UITextView*)textArea {
    return YES;
}
@end
