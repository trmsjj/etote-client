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
#import "ToteStore.h"
#import "Tote.h"

@interface SyncViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *syncActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *syncProgressBar;

@end

@implementation SyncViewController
@synthesize toteStatusLabel;
@synthesize gradientView;
@synthesize syncActivityIndicator;
@synthesize statusLabel;
@synthesize syncProgressBar;

- (IBAction)syncButtonSelected:(id)sender {
    [syncActivityIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [statusLabel setText:@"Syncing totes"];
            [syncProgressBar setProgress:0 animated:NO];
            [syncProgressBar setHidden:NO];
            
        });
        
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
        //PULL Documents Down
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [toteStatusLabel setText:@""];
            [statusLabel setText:@"Connecting To Server"];
            [syncProgressBar setProgress:0 animated:NO];
            [syncProgressBar setHidden:NO];
            
        });

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
    [toteStatusLabel setText:@""];
    NSArray *colors = [NSArray arrayWithObjects:[UIColor grayColor], [UIColor darkGrayColor], nil];
    [[self gradientView] setColors:colors];
}

- (void)viewWillAppear:(BOOL)animated
{
    [syncProgressBar setHidden:YES];
    [statusLabel setText:@""];
    if([[ToteStore sharedStore] unsyncedToteCount] > 0)
    {
        NSString *toteCountString = [NSString stringWithFormat:@"There are %u unsynced totes.", [[ToteStore sharedStore] unsyncedToteCount]];
        [toteStatusLabel setText:toteCountString];
    }
}

- (void)viewDidUnload
{
    [self setSyncActivityIndicator:nil];
    [self setStatusLabel:nil];
    [self setSyncProgressBar:nil];
    [self setToteStatusLabel:nil];
    [self setGradientView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
