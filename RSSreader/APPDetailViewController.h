//
//  APPDetailViewController.h
//  RSSreader
//
//  Created by Matthew Chan on 6/9/14.
//  Copyright (c) 2014 Matthew Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APPDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
