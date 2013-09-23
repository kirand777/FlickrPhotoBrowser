//
//  PhotoDownloader.m
//  FlickrPhotoBrowser
//
//  Created by admin on 17.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader ()
@property (nonatomic, strong, readwrite) NSURLConnection* connection;
@property (nonatomic, copy, readwrite) NSURLRequest* request;
@property (nonatomic, strong, readwrite) NSMutableData* mutableReceivedData;
@property (nonatomic, strong) UIImage* image;
@end

@implementation ImageDownloader

- (void)dealloc {
    [_request release];
    _request = nil;
    [_connection release];
    _connection = nil;
    [_mutableReceivedData release];
    _mutableReceivedData = nil;
    [_image release];
    _image = nil;
    
    [super dealloc];
}

- (NSData*) receivedData {
    return [self.mutableReceivedData copy];
}

- (id) initWithRequest: (NSURLRequest*) req {
    self = [super init];
    if (self) {
        _request = [req copy];
        _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
        _mutableReceivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.mutableReceivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.mutableReceivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIImage* im = [UIImage imageWithData:self.receivedData];
    if (im) {
        self.image = im;
        [[NSNotificationCenter defaultCenter] postNotificationName:ImageDownloaderDidFinishedLoadingNotification object:self];
    }
}

- (void)cancel { // added this
    if (!self.image) { // no point cancelling if we did the download
        // cancel download in progress, replace connection, start over
        [self.connection cancel];
        self->_connection = [[NSURLConnection alloc] initWithRequest:_request
                                                            delegate:self
                                                    startImmediately:NO];
    }
}

- (UIImage *)image {
    if (_image) {
        return _image;
    }
    [self.connection start];
    return nil;
}

@end
