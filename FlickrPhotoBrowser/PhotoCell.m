//
//  PhotoCell.m
//  FlickrPhotoBrowser
//
//  Created by admin on 17.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import "PhotoCell.h"

@implementation PhotoCell

- (void)dealloc {
    [_photoThumb release];
    [_photoTitle release];
    [_photo release];
    _delegate = nil;
    [super dealloc];
}

- (IBAction)deletePhoto:(id)sender {
    [self.delegate deletePhoto:self.photo];
}

- (IBAction)dupicatePhoto:(id)sender {
    [self.delegate duplicatePhoto:self.photo];
}
@end
