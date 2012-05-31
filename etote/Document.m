//
//  Document.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Document.h"

@implementation Document
@synthesize title;
@synthesize remoteURL;
@synthesize localPath;
@synthesize inTote;
@synthesize documentID;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:remoteURL forKey:@"remoteURL"];
    [aCoder encodeObject:localPath forKey:@"localPath"];
    [aCoder encodeBool:inTote forKey:@"inTotoe"];
    [aCoder encodeObject:documentID forKey:@"documentID"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.remoteURL = [aDecoder decodeObjectForKey:@"remoteURL"];
        self.localPath = [aDecoder decodeObjectForKey:@"localPath"];
        self.inTote = [aDecoder decodeBoolForKey:@"inTote"];
        self.documentID = [aDecoder decodeObjectForKey:@"documentID"];
    }
    return self;
}
@end
