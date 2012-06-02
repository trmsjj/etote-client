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

@implementation CategoriesViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        [self setTitle:@"Categories"];
        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkout"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(checkoutButtonSelected:)];
        self.navigationItem.rightBarButtonItem = settingsButton;
    }
    return self;
}

- (void)viewDidLoad
{
    OBGradientView *backgroundView = [[OBGradientView alloc] init];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor lightGrayColor], [UIColor blackColor], nil];
    [backgroundView setColors:colors];
    [[self tableView] setBackgroundView:backgroundView];
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
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
	[[self tableView] reloadData];
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
