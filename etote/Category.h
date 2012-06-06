//
//  Category.h
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject <NSCoding>
{
    NSString* name;
    NSMutableArray* documents;
}
@property NSString* name;
@property NSMutableArray* documents;

-(BOOL)allDocumentsSelected;
@end
