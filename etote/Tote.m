//
//  Tote.m
//  etote
//
//  Created by Ray Tiley on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tote.h"

@implementation Tote
@synthesize name;
@synthesize email;
@synthesize customerComments;
@synthesize documentIDs;
@synthesize owner;
@synthesize notes;
@synthesize synced;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:email forKey:@"email"];
    [aCoder encodeObject:customerComments forKey:@"customerComments"];
    [aCoder encodeObject:documentIDs forKey:@"documentIDs"];
    [aCoder encodeObject:owner forKey:@"owner"];
    [aCoder encodeObject:notes forKey:@"notes"];
    [aCoder encodeBool:synced forKey:@"synced"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.customerComments = [aDecoder decodeObjectForKey:@"customerComments"];
        self.documentIDs = [aDecoder decodeObjectForKey:@"documentIDs"];
        self.owner = [aDecoder decodeObjectForKey:@"owner"];
        self.notes = [aDecoder decodeObjectForKey:@"notes"];
        self.synced = [aDecoder decodeBoolForKey:@"synced"];
    }
    return self;
}
@end
