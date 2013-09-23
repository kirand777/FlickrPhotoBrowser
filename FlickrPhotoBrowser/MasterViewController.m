//
//  MasterViewController.m
//  FlickrPhotoBrowser
//
//  Created by admin on 16.03.13.
//  Copyright (c) 2013 Tornado. All rights reserved.
//

#import "MasterViewController.h"

#import "Photo.h"
#import "DetailViewController.h"
#import "PhotoCell.h"
#import "ImageDownloader.h"

static NSString *const CellIdentifier = @"PhotoCell";

@interface MasterViewController () <PhotoCellDelegate> {
    BOOL _registeredAsObserver;
}

@property (strong, nonatomic) NSTimer *reloadTimer;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Photo Browser", @"Photo Browser");
    }
    return self;
}
							
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_reloadTimer invalidate];
    [_reloadTimer release];
    [_detailViewController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tableView.rowHeight = 75.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil]
         forCellReuseIdentifier:CellIdentifier];
    
    self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(loadFailedPhotos) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_registeredAsObserver) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageDownloaded:)
                                                     name:ImageDownloaderDidFinishedLoadingNotification
                                                   object:nil];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imageDownloaded:(NSNotification*)note {
    ImageDownloader * imd = [note object];
    NSUInteger row = [self.photos indexOfObjectPassingTest:
                      ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                          return (((Photo*)obj).thumbDownloader == imd);
                      }];
    if (row == NSNotFound) return; // shouldn't happen
    NSIndexPath* ip = [NSIndexPath indexPathForRow:row inSection:0];
    NSArray* ips = [self.tableView indexPathsForVisibleRows];
    if ([ips indexOfObject:ip] != NSNotFound) {
        [self.tableView reloadRowsAtIndexPaths:@[ip]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)loadFailedPhotos {
    NSArray* ips = [self.tableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in ips) {
        PhotoCell *cell = (PhotoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        Photo *currPhoto = cell.photo;
        UIImage *currPhotoImage = currPhoto.thumbDownloader.image;
        if (!currPhotoImage) {
            NSLog(@"Reload started");
        }
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.photos) {
        return self.photos.count;
    }
    return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = (PhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo *currPhoto = (Photo *)self.photos[indexPath.row];
    cell.photo = currPhoto;
    
    cell.delegate = self;
    
    cell.photoTitle.text = currPhoto.photoTitle;
    UIImage *currPhotoImage = currPhoto.thumbDownloader.image;
    if (currPhotoImage) {
        cell.photoThumb.image = currPhotoImage;
    }
    else {
        cell.photoThumb.image = [UIImage imageNamed:@"loading.png"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
    }
    Photo *photo = self.photos[indexPath.row];
    self.detailViewController.photo = photo;
    self.detailViewController.master = self;
    [self presentViewController:self.detailViewController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.photos.count) {
        Photo *photo = (Photo *)self.photos[indexPath.row];
        ImageDownloader *imd = photo.thumbDownloader;
        [imd cancel];
    }
}

#pragma mark - PhotoCell Delegate Methods

- (void)deletePhoto:(Photo *)photo {
    
    NSUInteger row = [self.photos indexOfObject:photo];
    [self.photos removeObjectAtIndex:row];
    if (row == NSNotFound) return; // shouldn't happen
    
    NSIndexPath* ip = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (void)duplicatePhoto:(Photo *)photo {
    NSUInteger row = [self.photos indexOfObject:photo];
    NSUInteger index = row;
    while (index == row) {
        index = arc4random() % self.photos.count;
    }
    
    Photo *newPhoto = [[[Photo alloc] initWithPhotoID:photo.photoID photoTitle:photo.photoTitle photoURL:photo.photoURL] autorelease];

    [self.photos insertObject:newPhoto atIndex:index];

    NSIndexPath* ip = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

@end
