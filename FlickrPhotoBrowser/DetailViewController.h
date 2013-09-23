//
//  DetailViewController.h
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo, MasterViewController;
@interface DetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) MasterViewController *master;

@property (retain, nonatomic) IBOutlet UIImageView *photoImage;
@property (retain, nonatomic) IBOutlet UILabel *photoTitle;

- (IBAction)deletePhoto:(id)sender;
- (IBAction)done:(id)sender;

@end
