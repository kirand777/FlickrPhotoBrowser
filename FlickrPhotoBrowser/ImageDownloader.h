//
//  PhotoDownloader.h
//  FlickrPhotoBrowser
//
//  Created by admin on 17.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const ImageDownloaderDidFinishedLoadingNotification = @"ImageDownloaderDidFinishedLoadingNotification";

@interface ImageDownloader : NSObject

@property (nonatomic, strong, readonly) NSURLConnection* connection;
@property (nonatomic, strong, readonly) NSData* receivedData;
@property (nonatomic, strong, readonly) UIImage* image;

- (id)initWithRequest: (NSURLRequest*) req;
- (void)cancel;

@end
