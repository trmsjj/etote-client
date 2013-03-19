//
//  HomeViewController.m
//  etote
//
//  Created by Ray Tiley on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoriesViewController.h"
#import "SyncViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CategoriesStore.h"

@implementation HomeViewController
@synthesize gradientView;
@synthesize welcomeTextLabel;

- (void)getStarted:(id)sender {
    
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] init];
    [[categoriesViewController gridView] setBackgroundViewExtendsUp:NO];
    [[self navigationController] pushViewController:categoriesViewController animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(settingsButtonSelected:)];
        self.navigationItem.rightBarButtonItem = settingsButton;
    }
    return self;
}

- (void)settingsButtonSelected:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
	UITextField *passwordField = [alert textFieldAtIndex:0];
	passwordField.delegate = self;
    [alert setTag:1];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        NSString *submitted = [[alertView textFieldAtIndex:0] text];
        if(buttonIndex == 1 && [submitted isEqualToString:@"trms"])
        {
            NSLog(@"Load sync view controller");
            SyncViewController *syncViewController = [[SyncViewController alloc] init];
            [[self navigationController] pushViewController:syncViewController animated:YES];
        }
    }
    
    if (alertView.tag == 2) {
        if(buttonIndex == 0)
        {
            [[CategoriesStore sharedStore] emptyTote];
        }
        else
        {
            [self getStarted:nil];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	UIAlertView *alert = (UIAlertView *)[textField  superview];
	// call our handler first, then dismiss the box
	[self alertView:alert clickedButtonAtIndex:1];
    [alert setTag:1];
	[alert dismissWithClickedButtonIndex:1 animated:YES];
	return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Knock down font for iPhone
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [welcomeTextLabel setFont:[UIFont systemFontOfSize:12.0]];
    }
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor blackColor], nil];
    [[self gradientView] setColors:colors];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getStarted:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    int itemsInToteCount = [[CategoriesStore sharedStore] numberOfItemsInTote];
    if(itemsInToteCount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear your tote?" message:@"Would you like to clear your tote and start over?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        [alert setTag:2];
        [alert show];
    }
}

- (void)viewDidUnload
{
    [self setGradientView:nil];
    [self setWelcomeTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
