//
//  CategoriesStore.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Category;

@interface CategoriesStore : NSObject
{
    NSMutableArray *allCategories;
    
}
+ (CategoriesStore *)sharedStore;

- (NSArray *)allCategories;
- (Category *)createCategory;
@end
