//
//  SyncViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncViewController.h"
#import "SyncEngine.h"
#import "ToteStore.h"

@interface SyncViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *syncActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *syncProgressBar;

@end

@implementation SyncViewController
@synthesize toteStatusLabel;
@synthesize gradientView;
@synthesize syncActivityIndicator;
@synthesize statusLabel;
@synthesize syncProgressBar;

- (IBAction)syncButtonSelected:(id)sender 
{   
    [syncProgressBar setProgress:0];
    [syncProgressBar setHidden:NO];
    [syncActivityIndicator startAnimating];
    SyncEngine *syncEngine = [[SyncEngine alloc] init];
    [syncEngine setDelegate:self];
    [syncEngine startSync];
}

-(void)statusChangedTo:(NSString *)statusString
{
    [statusLabel setText:statusString];
}
-(void)progressChangedTo:(float)progress
{
    [syncProgressBar setProgress:progress animated:YES];
}
-(void)syncComlete
{
    [syncActivityIndicator stopAnimating];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Sync"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [toteStatusLabel setText:@""];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor blackColor], nil];
    [[self gradientView] setColors:colors];
}

- (void)viewWillAppear:(BOOL)animated
{
    [syncProgressBar setHidden:YES];
    [statusLabel setText:@""];
    if([[ToteStore sharedStore] unsyncedToteCount] > 0)
    {
        NSString *toteCountString = [NSString stringWithFormat:@"There are %u unsynced totes.", [[ToteStore sharedStore] unsyncedToteCount]];
        [toteStatusLabel setText:toteCountString];
    }
}

- (void)viewDidUnload
{
    [self setSyncActivityIndicator:nil];
    [self setStatusLabel:nil];
    [self setSyncProgressBar:nil];
    [self setToteStatusLabel:nil];
    [self setGradientView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end
