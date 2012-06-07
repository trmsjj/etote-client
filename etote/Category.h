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
    NSString* remoteImageURL;
    NSString* localImageURL;
    NSMutableArray* documents;
}
@property NSString* name;
@property NSMutableArray* documents;
@property NSString* remoteImageURL;
@property NSString* localImageURL;

-(BOOL)allDocumentsSelected;
@end
