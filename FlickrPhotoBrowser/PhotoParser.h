//
//  PhotoParser.h
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;
@interface PhotoParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong, readonly) NSMutableArray *parsedPhotos;
@property (nonatomic, strong) Photo *photo;

@end
