//
//  AssetViewController.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface AssetViewController : UITableViewController <QLPreviewControllerDataSource>

{
    NSMutableArray* assets;
}
@property NSMutableArray* assets;
@end
