//
//  DetailViewController.h
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
