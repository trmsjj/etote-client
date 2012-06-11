//
//  ETNavController.m
//  etote
//
//  Created by Ray Tiley on 6/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ETNavController.h"
#import "CategoriesViewController.h"
#import "CategoriesStore.h"

@implementation ETNavController


-(BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if(regularPop)
    {
        regularPop = FALSE;
        return YES;
    }
    
    if(alertViewClicked) {
        alertViewClicked = FALSE;
        return YES;
    }
    
    int itemsInToteCount = [[CategoriesStore sharedStore] numberOfItemsInTote];
    
    if([self.topViewController class] == [CategoriesViewController class] && itemsInToteCount > 0){

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Clear your tote?" message:@"Would you like to clear your tote and start over?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];


        [alert show];
        return NO;
        
    } else {
        regularPop = TRUE;
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [[CategoriesStore sharedStore] emptyTote];
        alertViewClicked = TRUE;
        [self popViewControllerAnimated:YES];
    }
}
@end
