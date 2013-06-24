//
//  ImageViewController.m
//  SPoT
//
//  Created by Jess Thrysoee on 21/6-2013.
//  Copyright (c) 2013 Jess Thrysoee. All rights reserved.
//


#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end

@implementation ImageViewController

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}


- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.navigationBar.topItem.title = title;
}


- (void)resetImage
{
    if (self.scrollView)
    {
        dispatch_queue_t queue = dispatch_queue_create("resetImage queue", NULL);
        dispatch_async(queue, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image && self.scrollView)
                {
                    self.scrollView.contentSize = CGSizeZero;
                    self.imageView.image = nil;
                    
                    self.scrollView.zoomScale = 1.0;
                    self.scrollView.contentSize = image.size;
                    self.imageView.image = image;
                    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                    
                    [self setZoomScale:NO];
                }
            });
        });
    }
}


- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    
    return _imageView;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    self.navigationBar.topItem.title = self.title;
    [self initSplitViewBarButtonItem];
    [self resetImage];
}


- (void)viewDidLayoutSubviews
{
    [self setZoomScale:NO];
}


- (void)setZoomScale:(BOOL)animated
{
    if (self.scrollView.bounds.size.width == 0 || !self.imageView.image)
    {
        return;
    }
    
    self.scrollView.maximumZoomScale = 5.0;
    
    CGFloat scrollViewAspect = self.scrollView.bounds.size.width / self.scrollView.bounds.size.height;
    CGFloat imageAspect = self.imageView.image.size.width / self.imageView.image.size.height;
    
    if (scrollViewAspect < imageAspect)
    {
        self.scrollView.minimumZoomScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
        [self.scrollView setZoomScale:(self.scrollView.bounds.size.height / self.imageView.image.size.height) animated:animated];
    }
    else
    {
        self.scrollView.minimumZoomScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
        [self.scrollView setZoomScale:(self.scrollView.bounds.size.width / self.imageView.image.size.width) animated:animated];
    }
}


// get current UIBarButtonItem from the splitViewController delegate if this has a barButtonItem property
- (void)initSplitViewBarButtonItem
{
    if (self.splitViewController && self.splitViewController.delegate)
    {
        if ([((id)self.splitViewController.delegate)respondsToSelector : @selector(barButtonItem)])
        {
            self.navigationBar.topItem.leftBarButtonItem = [((id)self.splitViewController.delegate)valueForKey : @"barButtonItem"];
        }
    }
}


- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationBar.topItem.leftBarButtonItem = barButtonItem;
}


- (void)setSplitViewBarButtonItemTitle:(NSString *)title
{
    self.navigationBar.topItem.leftBarButtonItem.title = title;
}


- (IBAction)tapRecognizer:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self setZoomScale:YES];
    }
}


@end
