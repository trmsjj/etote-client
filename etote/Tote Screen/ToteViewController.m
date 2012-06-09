//
//  ToteViewController.m
//  etote
//
//  Created by Ray Tiley on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToteViewController.h"
#import "CheckoutViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "Document.h"

@interface ToteViewController ()

@end

@implementation ToteViewController

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[CategoriesStore sharedStore] allCategories] count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else {
        // Return the number of rows in the section.
        int categoryIndex = section - 1;
        Category *category = [[[CategoriesStore sharedStore] allCategories] objectAtIndex:categoryIndex];
        int numberOfItemsInTote = 0;
        for(int i=0; i < [[category documents] count]; i++)
        {
            Document *doc = [[category documents] objectAtIndex:i];
            if(doc.inTote == YES)
            {
                numberOfItemsInTote++;
            }
        }
        return numberOfItemsInTote;
    }
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
        UIButton *clearToteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearToteButton setFrame:CGRectMake(0, 0, 120, 30)];
        NSString *buttonText = @"Clear Tote";
        [clearToteButton setTitle:buttonText forState:UIControlStateNormal];
        [clearToteButton addTarget:self action:@selector(clearTote) forControlEvents:UIControlEventTouchUpInside];
        [cell setAccessoryView:clearToteButton];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];  
    }
    else
    {
        int categoryIndex = indexPath.section - 1;

        Category *category = [[[CategoriesStore sharedStore] allCategories] objectAtIndex:categoryIndex];
        
        NSMutableArray *docsFromSectionInTote = [[NSMutableArray alloc] init];
        
        for(int i =0; i < [[category documents] count]; i++)
        {
            Document *doc = [[category documents] objectAtIndex:i];
            if(doc.inTote)
            {
                [docsFromSectionInTote addObject:doc];
            }
        }
        Document *doc = [docsFromSectionInTote objectAtIndex:indexPath.row];
        [[cell textLabel] setText:doc.title];
    }
    return cell;
}

-(void) clearTote
{
    [[CategoriesStore sharedStore] emptyTote];
    [[self tableView] reloadData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
@end
