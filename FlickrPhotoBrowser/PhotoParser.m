//
//  PhotoParser.m
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import "PhotoParser.h"
#import "Photo.h"

@interface PhotoParser ()
@property (nonatomic, strong) NSMutableArray *parsedPhotos;
@end

@implementation PhotoParser

- (void)dealloc {
    [_parsedPhotos release];
    _parsedPhotos = nil;
    [_photo release];
    _photo = nil;
    
    [super dealloc];
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"photos"]) {
        self.parsedPhotos = [[[NSMutableArray alloc] init] autorelease];
    }
    else if ([elementName isEqualToString:@"photo"]) {
        self.photo = [[[Photo alloc] initWithPhotoID:[attributeDict[@"id"] intValue]
                                          photoTitle:attributeDict[@"title"]
                                            photoURL:[[[NSURL alloc] initWithString:attributeDict[@"url"]] autorelease]] autorelease];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"photos"]) return;
    
    if ([elementName isEqualToString:@"photo"]) {
        [self.parsedPhotos addObject:self.photo];
        self.photo = nil;
    }    
}

@end
