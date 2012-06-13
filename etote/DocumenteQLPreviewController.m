//
//  DocumenteQLPreviewController.m
//  etote
//
//  Created by Scott Jann on 6/13/12.
//  Copyright (c) 2012 Scott Jann. All rights reserved.
//

#import "DocumenteQLPreviewController.h"

@implementation DocumenteQLPreviewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[self navigationItem] setRightBarButtonItem:nil];
}

@end
