//
//  ToteStore.h
//  etote
//
//  Created by Ray Tiley on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tote.h"

@interface ToteStore : NSObject
{
    NSMutableArray *allTotes;
    
}
+ (ToteStore *)sharedStore;

- (NSString *)itemsArchivePath;
- (BOOL)saveChanges;
- (NSArray *)allTotes;
- (Tote *)createTote;
- (int) unsyncedToteCount;
- (void) removeSynced;
@end
