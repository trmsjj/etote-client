//
//  CategoriesStore.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriesStore.h"
#import "Category.h"

@implementation CategoriesStore

- (id)init
{
    self = [super init];
    if(self) {
        allCategories = [[NSMutableArray alloc] init];
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
@end
