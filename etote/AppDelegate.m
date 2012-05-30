//
//  AppDelegate.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "CheckoutViewController.h"
#import "CategoriesViewController.h"
#import "SyncViewController.h"
#import "Category.h"
#import "CategoriesStore.h"
#import "Asset.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Setup Categories and Assets
    //Eventually this will be moved to the sync operation
    /*
    Category *carousel = [[CategoriesStore sharedStore] createCategory];
    carousel.name = @"Carousel";
    [carousel setAssets:[[NSMutableArray alloc] init]];
    
    Asset *carOverview = [[Asset alloc] init];
    [carOverview setTitle:@"Carousel Overview"];
    [carOverview setAssetRemoteURL:
     @"http://www.trms.com/assets/104/CarouselJAN2012.pdf"];
    [[carousel assets] addObject:carOverview];
    
    Asset *carProServer = [[Asset alloc] init];
    [carProServer setTitle:@"Carousel Pro Server"];
    [carProServer setAssetRemoteURL:
     @"http://www.trms.com/assets/142/CarouselProServer410.pdf"];
    [[carousel assets] addObject:carProServer];
    
    Category *cablecast = [[CategoriesStore sharedStore] createCategory];
    cablecast.name = @"Cablecast";
    [cablecast setAssets:[[NSMutableArray alloc] init]];
    
    Asset *cabOverview = [[Asset alloc] init];
    [cabOverview setTitle:@"Cablecast Overview"];
    [cabOverview setAssetRemoteURL:
     @"http://www.trms.com/assets/154/CablecastJAN262012.pdf"];
    [[cablecast assets] addObject:cabOverview];
    
    Asset *cabSX2HD = [[Asset alloc] init];
    [cabSX2HD setTitle:@"Cablecast SX2HD"];
    [cabSX2HD setAssetRemoteURL:
     @"http://www.trms.com/assets/192/CablecastSX2HD.pdf"];
    [[cablecast assets] addObject:cabSX2HD];

    
    Category *zeplay = [[CategoriesStore sharedStore] createCategory];
    zeplay.name = @"ZEPLAY";
    [zeplay setAssets:[[NSMutableArray alloc] init]];
    
    Asset *zeplayOverview = [[Asset alloc] init];
    [zeplayOverview setTitle:@"ZEPLAY Overview"];
    [zeplayOverview setAssetRemoteURL:
     @"http://www.trms.com/assets/136/ZEPLAYJan2012.pdf"];
    [[zeplay assets] addObject:zeplayOverview];

    //End CategoriesStore Setup
    */
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CheckoutViewController *checkoutViewController = [[CheckoutViewController alloc] init];
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] init];
    SyncViewController *syncViewController = [[SyncViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:categoriesViewController];
    
    [[navController tabBarItem] setTitle:@"Categories"];
    [[syncViewController tabBarItem] setTitle:@"Sync"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];

    NSArray *viewControllers = [NSArray arrayWithObjects:
                                navController,
                                checkoutViewController,
                                syncViewController, 
                                nil];
    
    [tabBarController setViewControllers:viewControllers];
    
    // Override point for customization after application launch.

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
