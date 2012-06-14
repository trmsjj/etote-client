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
@synthesize sendButton;
@synthesize clearToteButton;
@synthesize commentsTextArea;

- (IBAction)clearToteButtonSelected:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear your tote?" message:@"Are you sure you want to clear your tote?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    
    
    [alert show];
}

- (IBAction)saveButtonSelected:(id)sender {
    [[self emailField] resignFirstResponder];
    [[self nameField] resignFirstResponder];
    [[self commentsTextArea] resignFirstResponder];
    //Save tote to store.
    
    //validate tote
    if(([[nameField text] length] > 0 &&
       [[emailField text] length] > 0) == FALSE){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Required Fields" message:@"Please enter both your name and email address to continue" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
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
    [thankyouLabel setText:@"We will email you the literature when we get back to the office."];
    [[CategoriesStore sharedStore] emptyTote];
    [[CategoriesStore sharedStore] saveChanges];
    [[ToteStore sharedStore] saveChanges];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
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
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil]];
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
    [self setSendButton:nil];
    [self setClearToteButton:nil];
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

-(void) viewWillAppear:(BOOL)animated {
    int itemsCount = [[CategoriesStore sharedStore] numberOfItemsInTote];
if(itemsCount == 0) {
    [[self nameField] setEnabled:NO];
    [[self emailField] setEnabled:NO];
    [[self sendButton] setEnabled:NO];
    [[self commentsTextArea] setEditable:NO];
    [[self clearToteButton] setEnabled:NO];
    [thankyouLabel setText:@"You do not have any documents in your tote. Please go add some before checking out."];
}else {
    [[self nameField] setEnabled:YES];
    [[self emailField] setEnabled:YES];
    [[self sendButton] setEnabled:YES];
    [[self commentsTextArea] setEditable:YES];
    [[self clearToteButton] setEnabled:YES];
    NSString *labelText = [NSString stringWithFormat:
                           @"You have %u documents in your tote.", itemsCount];
    
    [thankyouLabel setText:labelText];
}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[CategoriesStore sharedStore] emptyTote];
        [self viewWillAppear:NO];
    }
}
@end
