//
//  DocumentsViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DocumentsViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "Document.h"
#import "OBGradientView.h"
#import "CheckoutViewController.h"

@implementation DocumentsViewController
@synthesize documents;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkout"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(checkoutButtonSelected:)];
        self.navigationItem.rightBarButtonItem = checkoutButton;     
    }
    return self;
}

- (void)checkoutButtonSelected:(id)sender {
    CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] init];
    [[self navigationController] pushViewController:checkoutViewController animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil]];
    
    OBGradientView *backgroundView = [[OBGradientView alloc] init];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor blackColor], nil];
    [backgroundView setColors:colors];
    [[self tableView] setBackgroundView:backgroundView];
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [instructions setBackgroundColor:[UIColor clearColor]];
    [instructions setText:@"Next take a look at our literature...\n\nJust like a shopping cart, if you find\nsomething you like just click the 'Add' button.\n\nDon't forget when you are done click the 'Checkout' button!"];
    [instructions setFont:[UIFont systemFontOfSize:25]];
    //[instructions setShadowColor:[UIColor blackColor]];
    //[instructions setShadowOffset:CGSizeMake(0, 1)];
    [instructions setTextColor:[UIColor whiteColor]];
    [instructions setLineBreakMode:UILineBreakModeWordWrap];
    [instructions setTextAlignment:UITextAlignmentCenter];
    [instructions setNumberOfLines:0];
    self.tableView.tableHeaderView = instructions;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QLPreviewController *preview = [[QLPreviewController alloc] init];
    
    [preview setDataSource:self];
    [preview setCurrentPreviewItemIndex:indexPath.row];
    
    [[self navigationController] pushViewController:preview animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else {
        return [documents count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    if(indexPath.section == 0)
    {
        [[cell textLabel] setText:@""];
        UIButton *addAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addAllButton setFrame:CGRectMake(0, 0, 120, 30)];
        NSString *buttonText = [self allDocumentsSelected] ? @"Remove All" : @"Add All";
        [addAllButton setTitle:buttonText forState:UIControlStateNormal];
        [addAllButton addTarget:self action:@selector(addAllButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [cell setAccessoryView:addAllButton];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];        
    }
    else 
    {
        
        Document *document = [documents objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[document title]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setFrame:CGRectMake(0, 0, 75, 30)];
        NSString *titleForButton = document.inTote ? @"Remove" : @"Add";
        [button setTitle:titleForButton forState:UIControlStateNormal];

        [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
        
        [cell setAccessoryView:button];
    }
    return cell;
}
- (void)addAllButtonTapped
{
    if([self allDocumentsSelected])
    {
        [self setDocumentInToteTo:NO];
    }
    else {
        [self setDocumentInToteTo:YES];
    }
    [[self tableView] reloadData];
}

- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Document *document = [documents objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    if([document inTote] == NO)
    {
        [document setInTote:YES];
        [button setTitle:@"Remove" forState:UIControlStateNormal];
    }
    else {
        [document setInTote:NO];
        [button setTitle:@"Add" forState:UIControlStateNormal];
    }
    [[self tableView] reloadData];
}

-(id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
	return [NSURL fileURLWithPath:[[documents objectAtIndex:index] localPath]];
}

- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return [documents count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)allDocumentsSelected
{
    for(int i=0; i < [documents count]; i++)
    {
        Document *doc = [documents objectAtIndex:i];
        if(doc.inTote == NO)
        {
            return NO;
        }
    }
    return YES;
}

- (void)setDocumentInToteTo:(BOOL)inTote
{
for(int i=0; i < [documents count]; i++)
{
    Document *doc = [documents objectAtIndex:i];
    doc.inTote = inTote;
}
}

@end
