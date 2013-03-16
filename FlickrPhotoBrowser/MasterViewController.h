//
//  MasterViewController.h
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
