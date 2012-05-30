//
//  Categories.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesViewController.h"
#import "Category.h"
#import "CategoriesStore.h"
#import "AssetViewController.h"

@implementation CategoriesViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //This is really ugly
    AssetViewController *assetView = [[AssetViewController alloc] init];
    CategoriesStore *store = [CategoriesStore sharedStore];
    NSMutableArray *assets = [[[store allCategories] objectAtIndex:[indexPath row]] assets];
    
    [assetView setAssets:assets];
    [[self navigationController] pushViewController:assetView animated:YES];
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

- (void)viewDidAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

@end
