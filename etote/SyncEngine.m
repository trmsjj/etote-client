//
//  SyncEngine.m
//  etote
//
//  Created by Ray Tiley on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncEngine.h"
#import "ToteStore.h"
#import "Tote.h"
#import "Document.h"
#import "Category.h"
#import "CategoriesStore.h"

@implementation SyncEngine
@synthesize server;
@synthesize delegate;

-(void) startSync
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_sync(dispatch_get_main_queue(), ^{
            [delegate statusChangedTo:@"Connecting to server."];
        });
        if ([self pingServer])
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [delegate statusChangedTo:@"Sending new eTotes to server."];
            });
            [self pushTotes];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [delegate statusChangedTo:@"Begin Syncing documents."];
            });
            [self pullCategoriesAndDocuments];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [delegate statusChangedTo:@"Sync Completed."];
            });
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [delegate statusChangedTo:@"Could not connect to server"];
            });
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [delegate syncComlete]; 
        });
    });
}
-(void) pullCategoriesAndDocuments
{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://etoteapp.herokuapp.com/api/v1/categories"]];
    
    NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *categoriesFromServer = [jsonResponse objectForKey:@"categories"];
    
    CategoriesStore *categoriesStore = [CategoriesStore sharedStore];
    [categoriesStore clearStore];
    for(int i=0; i < [categoriesFromServer count]; i++)
    {
        Category *newCategory = [categoriesStore createCategory];
        NSDictionary *category = [categoriesFromServer objectAtIndex:i];
        [newCategory setName:[category objectForKey:@"name"]];
        [newCategory setDocuments:[[NSMutableArray  alloc] init]];
        NSArray *documents = [category objectForKey:@"documents"];
        for(int j=0; j < [documents count]; j++)
        {
            Document *document = [[Document alloc] init];
            [document setTitle:[[documents objectAtIndex:j] objectForKey:@"name"]];
            [document setRemoteURL:[[documents objectAtIndex:j] objectForKey:@"url"]];
            [document setDocumentID:[[documents objectAtIndex:j] objectForKey:@"id"]];
            
            //Download Document
            NSURL  *url = [NSURL URLWithString:[document remoteURL]];
            
            NSArray *urlParts = [[document remoteURL] componentsSeparatedByString:@"/"];
            NSString *fileName = [urlParts lastObject];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            if ( urlData )
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate  statusChangedTo:[NSString stringWithFormat:@"%@\n%@", @"Downloading", fileName]];
                    [delegate progressChangedTo:((float)(j + 1) / (float)[documents count])];
                });
                
                NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString  *documentsDirectory = [paths objectAtIndex:0];  
                
                NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
                [document setLocalPath:filePath];
                [urlData writeToFile:filePath atomically:YES];
            }
            //Add Document to newCategory
            [[newCategory documents] addObject:document];
        }       
    }
}
-(void) pushTotes
{
    //PUSH Totes UP
    NSArray *totes = [[ToteStore sharedStore] allTotes];
    NSURL *postURL = [NSURL URLWithString:@"http://etoteapp.herokuapp.com/api/v1/requests"];
    for(int i=0; i< [totes count]; i++)
    {
        Tote *tote = [totes objectAtIndex:i];
        if(!tote.synced)
        {
            
            NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                      tote.name,@"name",
                                      tote.email,@"email",
                                      tote.documentIDs, @"documents",
                                      nil], @"request",
                                     nil];
            
            NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:request options:NSJSONWritingPrettyPrinted error:nil];
            NSString *test = [[NSString alloc] initWithData:jsonRequest encoding:NSUTF8StringEncoding];
            NSLog(@"%@", test);
            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90];
            [req setHTTPBody:jsonRequest];
            [req setHTTPMethod:@"POST"];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]] forHTTPHeaderField:@"Content-Length"];
            NSURLResponse *response = nil;
            NSError *error = nil;
            
            NSData *result = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
            
            tote.synced = YES;
        }
    }
}
-(BOOL)pingServer
{
    NSURL *url = [NSURL URLWithString:@"http://etoteapp.herokuapp.com/"];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:NULL];
    return (response != nil);
}

@end
