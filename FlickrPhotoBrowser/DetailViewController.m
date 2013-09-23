//
//  DetailViewController.m
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import "DetailViewController.h"
#import "Photo.h"
#import "ImageDownloader.h"
#import "MasterViewController.h"

@interface DetailViewController () {
    BOOL _registeredAsObserver;
}
- (void)configureView;
@end

@implementation DetailViewController

- (void)dealloc
{
    [_photo release];
    [_master release];
    [_photoImage release];
    [_photoTitle release];
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)setPhoto:(Photo *)photo
{
    if (_photo != photo) {
        [_photo release];
        _photo = [photo retain];

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.photo) {
        if (self.photo.bigImageDownloader.image) {
            self.photoImage.contentMode = UIViewContentModeScaleAspectFit;
            self.photoImage.image = self.photo.bigImageDownloader.image;
        }
        else {
            self.photoImage.contentMode = UIViewContentModeCenter;
            self.photoImage.image = [UIImage imageNamed:@"loading.png"];
        }
        self.photoTitle.text = self.photo.photoTitle;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_registeredAsObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageDownloaded:)
                                                     name:ImageDownloaderDidFinishedLoadingNotification
                                                   object:nil];
    }
}

- (void)imageDownloaded:(NSNotification*)note {
    ImageDownloader * imd = [note object];
    self.photoImage.image = imd.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Photo Detail", @"Photo Detail");
    }
    return self;
}
							
- (IBAction)deletePhoto:(id)sender {
    [self.master.photos removeObject:self.photo];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
