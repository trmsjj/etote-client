//
//  Categories.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CategoriesViewController.h"
#import "Category.h"
#import "CategoriesStore.h"
#import "DocumentsViewController.h"
#import "CheckoutViewController.h"
#import "OBGradientView.h"
#import "Document.h"
#import "ImageDemoGridViewCell.h"

@implementation CategoriesViewController

- (void)viewDidLoad
{
    [self setTitle:@"Categories"];
    
    UILabel *instructions = [[UILabel alloc] init];
    [instructions setBackgroundColor:[UIColor clearColor]];
    [instructions setOpaque:NO];
    [instructions setText:@"Now pick a product category"];
    [instructions setFont:[UIFont systemFontOfSize:30.0]];
    [instructions setShadowColor:[UIColor blackColor]];
    [instructions setShadowOffset:CGSizeMake(0, 1)];
    [instructions setTextColor:[UIColor whiteColor]];
    [instructions setLineBreakMode:UILineBreakModeWordWrap];
    [instructions setTextAlignment:UITextAlignmentCenter];
    [instructions setNumberOfLines:0];
    [instructions sizeToFit];
    
    self.gridView.gridHeaderView = instructions;
    
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkout"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(checkoutButtonSelected:)];
    

   
    
    self.navigationItem.rightBarButtonItem = checkoutButton;
    
    OBGradientView *backgroundView = [[OBGradientView alloc] init];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor blackColor], nil];
    [backgroundView setColors:colors];
    
    [self.gridView setBackgroundView:backgroundView];
    [self.gridView reloadData];
}

- (void)checkoutButtonSelected:(id)sender {
    CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] init];
    [[self navigationController] pushViewController:checkoutViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This is really ugly
    DocumentsViewController *documentsView = [[DocumentsViewController alloc] init];
    CategoriesStore *store = [CategoriesStore sharedStore];
    
    NSMutableArray *documents = [[[store allCategories] objectAtIndex:[indexPath row]] documents];
    [documentsView setDocuments:documents];
    
    [[self navigationController] pushViewController:documentsView animated:YES];
}





- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CategoriesStore sharedStore] allCategories] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        
    if(!cell)
    {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    Category *category = [[[CategoriesStore sharedStore] allCategories] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[category name]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, 150, 30)];
    NSString *titleForButton = category.allDocumentsSelected ? @"Remove All" : @"Add All";
    [button setTitle:titleForButton forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    
    [cell setAccessoryView:button];
    
    return cell;
}

- (void)checkButtonTapped:(id)sender event:(id)event
{   /*
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil)
    {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
    }
    */
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    Category *category = [[[CategoriesStore sharedStore] allCategories] objectAtIndex:[indexPath row]];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    BOOL inTote = NO;
    if([category allDocumentsSelected] == NO)
    {
        
        inTote = YES;
        [button setTitle:@"Remove All" forState:UIControlStateNormal];
    }
    else {
        inTote = NO;
        [button setTitle:@"Add All" forState:UIControlStateNormal];
    }
    for(int i=0; i < [[category documents] count]; i++)
    {
        Document *doc = [[category documents] objectAtIndex:i];
        [doc setInTote:inTote];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
	[[self tableView] reloadData];
	[super viewWillAppear:animated];
    */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


//Grid View Stuff
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return [[[CategoriesStore sharedStore] allCategories] count];
}

-(void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{
    //This is really ugly
    DocumentsViewController *documentsView = [[DocumentsViewController alloc] init];
    CategoriesStore *store = [CategoriesStore sharedStore];
    
    NSMutableArray *documents = [[[store allCategories] objectAtIndex:index] documents];
    [documentsView setDocuments:documents];
    
    [[self navigationController] pushViewController:documentsView animated:YES];
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    Category *category = [[[CategoriesStore sharedStore] allCategories] objectAtIndex:index];
    static NSString * PlainCellIdentifier = @"PlainCellIdentifier";
    //static NSString * OffsetCellIdentifier = @"OffsetCellIdentifier";
    
    AQGridViewCell * cell = nil;

    ImageDemoGridViewCell * plainCell = (ImageDemoGridViewCell *)[aGridView dequeueReusableCellWithIdentifier: PlainCellIdentifier];
    if ( plainCell == nil )
    {
        plainCell = [[ImageDemoGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 350, 300)
                                                 reuseIdentifier: PlainCellIdentifier];
    }
    
    plainCell.image = [UIImage imageWithContentsOfFile:[category localImageURL]];
    
    cell = plainCell;
            
    return ( cell );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    return ( CGSizeMake(350, 300) );
}

@end
