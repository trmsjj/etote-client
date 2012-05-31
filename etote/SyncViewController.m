//
//  SyncViewController.m
//  etote
//
//  Created by Ray Tiley on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncViewController.h"
#import "CategoriesStore.h"
#import "Category.h"
#import "Document.h"

@interface SyncViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *syncActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *syncProgressBar;

@end

@implementation SyncViewController
@synthesize syncActivityIndicator;
@synthesize statusLabel;
@synthesize syncProgressBar;

- (IBAction)syncButtonSelected:(id)sender {
    [syncActivityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"About to update label");
            [statusLabel setText:@"Connecting To Server"];
            [syncProgressBar setProgress:0 animated:NO];
            [syncProgressBar setHidden:NO];
            
        });

        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://etoteapp.herokuapp.com/api/v1/categories"]];
        
        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSArray *categoriesFromServer = [jsonResponse objectForKey:@"categories"];
        
        CategoriesStore *categoriesStore = [CategoriesStore sharedStore];
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
                        [statusLabel setText:[NSString stringWithFormat:@"%@ %@", @"Downloading", fileName]];
                        NSLog(@"Progress: %f", ((float)j / (float)[documents count]));
                        [syncProgressBar setProgress:((float)(j + 1) / (float)[documents count]) animated:YES];
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
        dispatch_sync(dispatch_get_main_queue(), ^{
            [statusLabel setText:@"Sync Complete"];
            [syncActivityIndicator stopAnimating];
        });

    });
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Sync"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [syncProgressBar setHidden:YES];
    [statusLabel setText:@""];
}

- (void)viewDidUnload
{
    [self setSyncActivityIndicator:nil];
    [self setStatusLabel:nil];
    [self setSyncProgressBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
