//
//  Photo.h
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImageDownloader;
@interface Photo : NSObject

@property (assign, nonatomic) NSUInteger photoID;
@property (copy, nonatomic) NSString *photoTitle;
@property (copy, nonatomic) NSURL *photoURL;
@property (strong, nonatomic) ImageDownloader *thumbDownloader;
@property (strong, nonatomic) ImageDownloader *bigImageDownloader;

- (id)initWithPhotoID:(NSUInteger)photoID photoTitle:(NSString *)photoTitle photoURL:(NSURL *)photoURL;

@end