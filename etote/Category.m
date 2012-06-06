//
//  Category.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Category.h"
#import "Document.h"

@implementation Category
    @synthesize name;
    @synthesize documents;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:documents forKey:@"documents"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.documents = [aDecoder decodeObjectForKey:@"documents"];
    }
    return self;
}

-(BOOL)allDocumentsSelected
{
    BOOL allDocsInTote = YES;
    for(int i=0; i < [documents count]; i++)
    {
        Document *doc = [documents objectAtIndex:i];
        if(doc.inTote == NO)
        {
            allDocsInTote = NO;
            break;
        }
    }
    return allDocsInTote;
}
@end
