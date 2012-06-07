//
//  SyncEngine.h
//  etote
//
//  Created by Ray Tiley on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SyncEngine;
@protocol SyncEngineDelegate <NSObject>

@optional
- (void)progressChangedTo:(float)progress;
- (void)statusChangedTo:(NSString *)statusString;
- (void)syncComlete;
@end

@interface SyncEngine : NSObject
{
    id <SyncEngineDelegate> delegate;
}
@property id <SyncEngineDelegate> delegate;
-(BOOL)pingServer;
-(void)startSync;

@end
