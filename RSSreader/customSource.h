//
//  customSource.h
//  oneLife
//
//  Created by Matthew Chan on 7/28/14.
//  Copyright (c) 2014 Matthew Chan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "RSSParser.h"

@interface customSource : UITableViewController <RSSParserClassDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *sourceName;
@property (strong, nonatomic) IBOutlet UITextField *sourceURL;
@property (nonatomic, strong) DataModel *data;

- (IBAction)add;
- (IBAction)cancel;

@end
