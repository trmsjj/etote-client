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

@end

@implementation SyncViewController
@synthesize syncActivityIndicator;

- (IBAction)syncButtonSelected:(id)sender {
    [syncActivityIndicator startAnimating];
    
    //TODO - Do all this async so the UI doesn't freeze up
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
    [syncActivityIndicator stopAnimating];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setSyncActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
