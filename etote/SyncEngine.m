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
    NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    NSData *data = [NSData dataWithContentsOfURL:
                    [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", server, @"/api/v1/categories"]]];
    
    NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSArray *categoriesFromServer = [jsonResponse objectForKey:@"categories"];
    int documentsDownloaded = 0;
    int totalDocuments = 0;
    for(int i=0; i < [categoriesFromServer count]; i++)
    {
        NSDictionary *category = [categoriesFromServer objectAtIndex:i];
        NSArray *documents = [category objectForKey:@"documents"];
        totalDocuments += [documents count];
    }
    
    CategoriesStore *categoriesStore = [CategoriesStore sharedStore];
    [categoriesStore clearStore];
    for(int i=0; i < [categoriesFromServer count]; i++)
    {
        Category *newCategory = [categoriesStore createCategory];
        NSDictionary *category = [categoriesFromServer objectAtIndex:i];
        [newCategory setName:[category objectForKey:@"name"]];
        [newCategory setRemoteImageURL:[category objectForKey:@"image_url"]];
        
        //Download Document
        NSURL  *url = [NSURL URLWithString:[newCategory remoteImageURL]];
        
        NSArray *urlParts = [[newCategory remoteImageURL] componentsSeparatedByString:@"/"];
        NSString *fileName = [urlParts lastObject];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [delegate  statusChangedTo:[NSString stringWithFormat:@"%@\n%@", @"Downloading", fileName]];
            });
            
            NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];  
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
            [newCategory setLocalImageURL:filePath];
            [urlData writeToFile:filePath atomically:YES];
        }
        
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
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            
            if ( urlData )
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate  statusChangedTo:[NSString stringWithFormat:@"%@\n%@", @"Downloading", fileName]];
                    [delegate progressChangedTo:((float)(documentsDownloaded + 1) / totalDocuments)];
                });

                [urlData writeToFile:[document localPath] atomically:YES];
            }
            //Add Document to newCategory
            documentsDownloaded++;
            [[newCategory documents] addObject:document];
        }       
    }
}
-(void) pushTotes
{
    //PUSH Totes UP
    NSArray *totes = [[ToteStore sharedStore] allTotes];
    NSString *owner = [[NSUserDefaults standardUserDefaults] objectForKey:@"owner"];
    NSString *server = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", server, @"/api/v1/totes"]];
    for(int i=0; i< [totes count]; i++)
    {
        Tote *tote = [totes objectAtIndex:i];
        if(!tote.synced)
        {
            //Fix for nil owner comments
            NSString *ownerComments = tote.notes ? tote.notes : @"";
            NSDictionary *request = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSDictionary dictionaryWithObjectsAndKeys:
                                      tote.name,@"name",
                                      tote.customerComments,@"customer_comments",
                                      ownerComments,@"owner_comments",
                                      owner,@"owner",
                                      tote.email,@"email",
                                      tote.documentIDs, @"documents",
                                      nil], @"tote",
                                     nil];
            
            NSData *jsonRequest = [NSJSONSerialization dataWithJSONObject:request 
                                                                  options:NSJSONWritingPrettyPrinted 
                                                                    error:nil];

            NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90];
            
            [req setHTTPBody:jsonRequest];
            [req setHTTPMethod:@"POST"];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setValue:[NSString stringWithFormat:@"%d", [jsonRequest length]]forHTTPHeaderField:@"Content-Length"];
            
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            
           NSData *returnData = [NSURLConnection sendSynchronousRequest:req
                                 returningResponse:&response
                                             error:&error];
            
            
            if([response statusCode] == 201)
            {
                tote.synced = YES;
            }
            else
            {
                NSString *response = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", response);
            }
        }
    }
}
-(BOOL)pingServer
{
    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"server"]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:NULL];
    return (response != nil);
}

@end
