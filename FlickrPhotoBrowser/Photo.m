//
//  Photo.m
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import "Photo.h"
#import "ImageDownloader.h"

@implementation Photo

- (void)dealloc {
    
    [_photoTitle release];
    _photoTitle = nil;
    [_photoURL release];
    _photoURL = nil;
    [_thumbDownloader release];
    _thumbDownloader = nil;
    [_bigImageDownloader release];
    _bigImageDownloader = nil;
    
    [super dealloc];
}

- (NSString *)appendSuffixToPath:(NSString *)path suffix:(NSString *)suffix {
    NSString * fileExtension = [NSString stringWithFormat:@".%@", [path pathExtension]];
    NSString * sufWithExt = [NSString stringWithFormat:@"%@%@", suffix, fileExtension];
    
    return [path stringByReplacingOccurrencesOfString:fileExtension withString:sufWithExt];
}

- (id)initWithPhotoID:(NSUInteger)photoID photoTitle:(NSString *)photoTitle photoURL:(NSURL *)photoURL {
    self = [super init];
    if (self) {
        _photoID = photoID;
        _photoTitle = [photoTitle copy];
        _photoURL = [photoURL retain];
        if (_photoURL) {
            
            NSString *thumbPath = [self appendSuffixToPath:[_photoURL absoluteString] suffix:@"_s"];
            
            NSURLRequest* thumbReq = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbPath] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            ImageDownloader * thumbImd = [[ImageDownloader alloc] initWithRequest:thumbReq];
            _thumbDownloader = thumbImd;
            
            NSURLRequest* bigImageReq = [NSURLRequest requestWithURL:_photoURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            ImageDownloader * bigImageImd = [[ImageDownloader alloc] initWithRequest:bigImageReq];
            _bigImageDownloader = bigImageImd;
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Photo {\rid:%i;\rtitle:%@;\rurl:%@\r}", self.photoID, self.photoTitle, self.photoURL];
}

@end
