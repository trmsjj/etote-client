//
//  AppDelegate.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "CategoriesStore.h"
#import "ToteStore.h"
#import "ETNavController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    
    ETNavController *navController = [[ETNavController alloc] initWithRootViewController:homeViewController];
    [[navController navigationBar] setTintColor:[UIColor colorWithRed:((float)234 / (float)255) green:((float)179/(float)255) blue:((float)43/(float)255) alpha:0.7]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[CategoriesStore sharedStore] saveChanges];
    if(!success)
    {
        NSLog(@"Error archiving categories");
    }
    success = [[ToteStore sharedStore] saveChanges];
    if(!success)
    {
        NSLog(@"Error archiving totes");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
