//
//  Asset.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Asset : NSObject {
    NSString* title;
    NSString* assetRemoteURL;
    NSString* assetLocalURL;
    BOOL inTote;
    NSNumber* assetID;
}
@property NSString* title;
@property NSString* assetRemoteURL;
@property NSString* assetLocalURL;
@property BOOL inTote;
@property NSNumber* assetID;
@end
