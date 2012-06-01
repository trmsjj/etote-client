//
//  Tote.h
//  etote
//
//  Created by Ray Tiley on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tote : NSObject
{
    NSString *name;
    NSString *email;
    NSString *customerComments;
    NSMutableArray *documentIDs;
    NSString *owner;
    NSString *notes;
    BOOL synced;
}
@property NSString *name;
@property NSString *email;
@property NSString *customerComments;
@property NSMutableArray *documentIDs;
@property NSString *owner;
@property NSString *notes;
@property BOOL synced;
@end
