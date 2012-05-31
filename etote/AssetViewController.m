//
//  AssetViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AssetViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "Asset.h"

@implementation AssetViewController
@synthesize assets;

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
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
    return [assets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    Asset *asset = [assets objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[asset title]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, 75, 30)];
    NSString *titleForButton = asset.inTote ? @"Remove" : @"Add";
    [button setTitle:titleForButton forState:UIControlStateNormal];

    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    
    [cell setAccessoryView:button];
    
    
    return cell;
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
    Asset *asset = [assets objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    if([asset inTote] == NO)
    {
        [asset setInTote:YES];
        [button setTitle:@"Remove" forState:UIControlStateNormal];
    }
    else {
        [asset setInTote:NO];
        [button setTitle:@"Add" forState:UIControlStateNormal];
    }


    

}

-(id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    Asset *asset = [assets objectAtIndex:index];

	return [NSURL fileURLWithPath:[asset assetLocalURL]];
    
}

- (NSInteger) numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return [assets count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}
@end
