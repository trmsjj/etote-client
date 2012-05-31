//
//  Docuement.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject {
    NSString* title;
    NSString* remoteURL;
    NSString* localPath;
    BOOL inTote;
    NSNumber* documentID;
}
@property NSString* title;
@property NSString* remoteURL;
@property NSString* localPath;
@property BOOL inTote;
@property NSNumber* documentID;
@end
