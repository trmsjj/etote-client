//
//  CategoriesStore.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesStore.h"
#import "Category.h"
#import "Document.h"

@implementation CategoriesStore

- (id)init
{
    self = [super init];
    if(self) 
    {
        NSString *path = [self itemsArchivePath];
        allCategories = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if(!allCategories)
        {
            allCategories = [[NSMutableArray alloc] init];
        }
        
    }
    return self;
}

- (NSArray *)allCategories
{
    return allCategories;
}

- (Category *)createCategory
{
    Category *category = [[Category alloc] init];
    [allCategories addObject:category];
    return category;
}

//Create a Singleton sharedStore
+ (CategoriesStore *)sharedStore
{
    static CategoriesStore *sharedStore =  nil;
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

- (void)clearStore
{
    allCategories = nil;
    allCategories = [[NSMutableArray alloc] init];
}

-(void)emptyTote
{
    for(int i=0; i < [allCategories count]; i++)
    {
        Category *category = [allCategories objectAtIndex:i];
        for(int j=0; j < [[category documents] count]; j++)
        {
            Document *document = [[category documents] objectAtIndex:j];
            [document setInTote:NO];
        }
    }
}

-(NSString *)itemsArchivePath
{

    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"categories.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemsArchivePath];
    return [NSKeyedArchiver archiveRootObject:allCategories toFile:path];
}

-(NSInteger)numberOfItemsInTote
{
    int toteItemCount = 0;
    for(int i=0; i < [allCategories count]; i++)
    {
        NSMutableArray *documents = [[allCategories objectAtIndex:i] documents];
        for(int j=0; j < [documents count]; j++)
        {
            Document *doc = [documents objectAtIndex:j];
            if(doc.inTote == YES)
            {
                toteItemCount++;
            }
        }
    }
    return toteItemCount;
}

@end
