//
//  ToteStore.m
//  etote
//
//  Created by Ray Tiley on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ToteStore.h"

@implementation ToteStore
- (id)init
{
    self = [super init];
    if(self) 
    {
        NSString *path = [self itemsArchivePath];
        allTotes = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(!allTotes)
        {
            allTotes = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (NSArray *)allTotes
{
    return allTotes;
}

- (Tote *)createTote
{
    Tote *tote = [[Tote alloc] init];
    [allTotes addObject:tote];
    return tote;
}

//Create a Singleton sharedStore
+ (ToteStore *)sharedStore
{
    static ToteStore *sharedStore =  nil;
    if(!sharedStore)
    {
        sharedStore = [[super allocWithZone:nil] init];   
    }
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(NSString *)itemsArchivePath
{
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"totes.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:allTotes toFile:path];
}

-(int) unsyncedToteCount
{
    int returnCount = 0;
    for(int i=0;  i < [allTotes count]; i++)
    {
        if(![[allTotes objectAtIndex:i] synced])
        {
            returnCount++;
        }
    }
    return returnCount;
}
@end
