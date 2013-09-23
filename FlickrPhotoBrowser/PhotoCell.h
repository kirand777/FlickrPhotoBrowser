//
//  PhotoCell.h
//  FlickrPhotoBrowser
//
//  Created by admin on 17.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;

@protocol PhotoCellDelegate;

@interface PhotoCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *photoThumb;
@property (retain, nonatomic) IBOutlet UILabel *photoTitle;
@property (retain, nonatomic) Photo *photo;
@property (assign, nonatomic) id<PhotoCellDelegate> delegate;

- (IBAction)deletePhoto:(id)sender;
- (IBAction)dupicatePhoto:(id)sender;


@end

@protocol PhotoCellDelegate <NSObject>
@required
- (void)deletePhoto:(Photo *)photo;
- (void)duplicatePhoto:(Photo *)photo;

@end