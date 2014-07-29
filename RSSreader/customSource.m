//
//  customSource.m
//  oneLife
//
//  Created by Matthew Chan on 7/28/14.
//  Copyright (c) 2014 Matthew Chan. All rights reserved.
//

#import "customSource.h"

@interface customSource () {
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
    
    RSSParser *testParser;
    NSTimer *nst;
    
    dispatch_queue_t myQueue;
}

@end

@implementation customSource

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myQueue = dispatch_queue_create("TestQueue", NULL);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add
{
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 50, 170, 170)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = UITextAlignmentCenter;
    loadingLabel.text = @"Verifying source...";
    [loadingView addSubview:loadingLabel];
    
    [self.view addSubview:loadingView];
    [activityView startAnimating];
    
    nst = [NSTimer timerWithTimeInterval:15 target:self selector:@selector(verifyTimeOut) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:nst forMode:NSDefaultRunLoopMode];
    
    testParser = [[RSSParser alloc] init];
    [testParser setDelegate:self];
    dispatch_async(myQueue, ^{
        [testParser startParse:self.sourceURL.text sourceName:self.sourceName.text amountToParse:3];
    });
}

- (void) RSSParserDidReturnFeed:(NSMutableArray *)returnedFeed
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
    [nst invalidate];
    if (returnedFeed != nil) {
        if (returnedFeed.count>0) {
            NSMutableDictionary *newSource = [[NSMutableDictionary alloc] init];
            [newSource setObject:self.sourceName.text forKey:@"title"];
            [newSource setObject:@"customsource" forKey:@"identifier"];
            [newSource setObject:self.sourceURL.text forKey:@"url"];
            [newSource setObject:@"Articles.png" forKey:@"icon"];
            [self.data.source_list addObject:newSource];
            self.data.changed = TRUE;
            
            [activityView stopAnimating];
            [loadingView removeFromSuperview];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [activityView stopAnimating];
            [loadingView removeFromSuperview];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Add Source"
                                                            message:@"Sorry, the oneLife was unable to find any information within the provided link."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        [activityView stopAnimating];
        [loadingView removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Add Source"
                                                        message:@"Sorry, the oneLife was unable to find any information within the provided link."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    });
}

- (void) verifyTimeOut
{
    [testParser destroyParse];
    [activityView stopAnimating];
    [loadingView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Add Source"
                                                    message:@"Sorry, the oneLife was unable to find any information within the provided link."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
