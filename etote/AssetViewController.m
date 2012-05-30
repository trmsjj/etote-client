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
    
    UIImage *image = ([asset inTote]) ? [UIImage   imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(checkButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    cell.accessoryView = button;
    
    
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
    if([asset inTote] == NO)
    {
        [asset setInTote:YES];
    }
    else {
        [asset setInTote:NO];
    }

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = (UIButton *)cell.accessoryView;
    
    UIImage *newImage = ([asset inTote]) ? [UIImage imageNamed:@"checked.png"] : [UIImage imageNamed:@"unchecked.png"];
    [button setBackgroundImage:newImage forState:UIControlStateNormal];
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
@end
