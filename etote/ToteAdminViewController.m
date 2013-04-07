//
//  TodeAdminViewController.m
//  etote
//
//  Created by Ray Tiley on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToteAdminViewController.h"
#import "ToteStore.h"
#import "Tote.h"
#import "AdminEditToteViewController.h"
@interface ToteAdminViewController ()

@end

@implementation ToteAdminViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {   
    }
    return self;
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Admin";
    } else
        return @"Totes";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    else
        return [[[ToteStore sharedStore] allTotes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        NSString *CellIdentifier = @"ActionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ActionCell"];
        }
        
        cell.textLabel.text = @"Remove Synced Totes";
    
        return cell;
    }
    
    if (indexPath.section == 1) {
        NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }
        NSArray *totes = [[ToteStore sharedStore] allTotes];
        //Reverse the array
        NSArray *reversed = [[totes reverseObjectEnumerator] allObjects];

        Tote *tote = [reversed objectAtIndex:indexPath.row];
        [[cell textLabel] setText:tote.name];
        [[cell detailTextLabel] setText:tote.email];
        if (tote.synced) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        return cell;
    }
    return NULL;
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
    if(indexPath.section == 0) {
        [[ToteStore sharedStore] removeSynced];
        [self.tableView reloadData];
    } else {
        NSArray *totes = [[ToteStore sharedStore] allTotes];
        //Reverse the array
        NSArray *reversed = [[totes reverseObjectEnumerator] allObjects];
        
        AdminEditToteViewController *editView = [[AdminEditToteViewController alloc] init];
        Tote *tote = [reversed objectAtIndex:indexPath.row];
        editView.tote = tote;
        [[self navigationController] pushViewController:editView animated:YES];
    }
    
}

@end
