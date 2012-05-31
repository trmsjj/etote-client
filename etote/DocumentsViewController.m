//
//  DocumentsViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DocumentsViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "Document.h"

@implementation DocumentsViewController
@synthesize documents;

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
    return [documents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    Document *document = [documents objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[document title]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, 75, 30)];
    NSString *titleForButton = document.inTote ? @"Remove" : @"Add";
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
@end
