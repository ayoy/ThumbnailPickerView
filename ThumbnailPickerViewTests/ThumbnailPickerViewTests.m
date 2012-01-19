//
//  ThumbnailPickerViewTests.m
//  ThumbnailPickerViewTests
//
//  Created by Dominik Kapusta on 12-01-18.
//  Copyright (c) 2012 Dominik Kapusta.
//
//  Latest code can be found on GitHub: https://github.com/ayoy/ThumbnailPickerView
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ThumbnailPickerViewTests.h"
#import "ThumbnailPickerView.h"

// helper #defines
#define THUMB_WIDTH       17    // 16px + 1px spacing
#define THUMB_TAG_OFFSET 100


#pragma mark - Data Source class

@interface DataSource : NSObject <ThumbnailPickerViewDataSource>
@property (nonatomic, assign) NSUInteger numberOfImages;
@end

@implementation DataSource

@synthesize numberOfImages = _numberOfImages;

- (NSUInteger)numberOfImagesForThumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView
{
    return self.numberOfImages;
}

- (UIImage *)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView imageAtIndex:(NSUInteger)index
{
    return [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"image001" ofType:@"jpg"]];
}

@end


#pragma mark - Tests class

@implementation ThumbnailPickerViewTests

#pragma mark - helpers

- (NSUInteger)visibleThumbnailsCountForThumbnailPickerView:(ThumbnailPickerView *)view
{
    NSUInteger visibleThumbnailsCount = 0;
    SEL selector = @selector(visibleThumbnailsCount);
    NSMethodSignature *signature = [[ThumbnailPickerView class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = selector;
    invocation.target = view;
    [invocation invoke];
    
    [invocation getReturnValue:&visibleThumbnailsCount];
    
    return visibleThumbnailsCount;
}

- (void)setUp
{
    [super setUp];
    thumbnailPickerView = [[ThumbnailPickerView alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}


#pragma mark - tests

- (void)testNoVisibleThumbnailsWithNilDataSource
{
    STAssertNil(thumbnailPickerView.dataSource, @"Data source should initially be nil");
    [thumbnailPickerView reloadData];
    
    NSUInteger visibleThumbnailsCount = [self visibleThumbnailsCountForThumbnailPickerView:thumbnailPickerView];
    STAssertEquals(visibleThumbnailsCount, 0u, @"Should have 0 visible thumbnails with nil data source");
}

- (void)testCenteringThumbnailsInView
{
    DataSource *dataSource = [[DataSource alloc] init];
    dataSource.numberOfImages = 1;
    thumbnailPickerView.dataSource = dataSource;
    
    UIView *contentView;
    UIView *thumbnailView;
    for (int i = 1; i <= 10; i++) {
        for (int j = 1; j <= 10; j++) {
            thumbnailPickerView.frame = CGRectMake(0, 0, i*150, (11-j)*50);
            [thumbnailPickerView layoutSubviews];
            contentView = [thumbnailPickerView performSelector:@selector(contentView)];
            thumbnailView = [contentView viewWithTag:THUMB_TAG_OFFSET]; // index 0

            STAssertTrue(CGRectEqualToRect(contentView.bounds, thumbnailView.frame), @"Thumbnail should be placed right inside content view");

            // note: normally we should convert thumbnailPicker.view center from its parent
            // but we don't have to since it doesn't have a parent in this unit test
            STAssertTrue(CGPointEqualToPoint(contentView.center, thumbnailPickerView.center), @"Content view should be centerd within thumbnail picker view");
        }
    }
}


- (void)testLimitVisibleThumbnailsAmountToFitViewWidth
{
    thumbnailPickerView.frame = CGRectMake(0, 0, 200, 50);
    DataSource *dataSource = [[DataSource alloc] init];
    dataSource.numberOfImages = 50;

    thumbnailPickerView.dataSource = dataSource;
    [thumbnailPickerView reloadData];

    NSUInteger visibleThumbnailsCount = [self visibleThumbnailsCountForThumbnailPickerView:thumbnailPickerView];
    STAssertTrue(visibleThumbnailsCount > 0, @"Visible thumbnails count should be greater than zero");
    
    UIView *contentView = [thumbnailPickerView performSelector:@selector(contentView)];

    NSUInteger expectedThumbnailsCount;
    NSArray *subviews = nil;
    for (int i = 0; i < 10; i++) {
        thumbnailPickerView.frame = CGRectMake(0, 0, i*150, 50); // 0...1350
        [thumbnailPickerView reloadData];
        visibleThumbnailsCount = [self visibleThumbnailsCountForThumbnailPickerView:thumbnailPickerView];

        subviews = contentView.subviews;
        STAssertEquals(visibleThumbnailsCount, subviews.count, @"Content view's subviews count different from visible thumbnails count");

        // width plus 1, because we divide by thumb width plus spacing, but
        // the rightmost thumbnail doesn't have a spacing after itself
        expectedThumbnailsCount = (thumbnailPickerView.frame.size.width+1)/THUMB_WIDTH;
        expectedThumbnailsCount = MIN(expectedThumbnailsCount, dataSource.numberOfImages);
        STAssertEquals(visibleThumbnailsCount, expectedThumbnailsCount, @"Incorrect visible thumbnails count");
    }
}

- (void)testFirstSubviewContainsFistDataSourceImage
{
    thumbnailPickerView.frame = CGRectMake(0, 0, 200, 50);
    DataSource *dataSource = [[DataSource alloc] init];
    dataSource.numberOfImages = 50;
    
    thumbnailPickerView.dataSource = dataSource;
    [thumbnailPickerView reloadData];
    
    UIView *contentView = [thumbnailPickerView performSelector:@selector(contentView)];
    
    NSArray *subviews = nil;
    CGPoint hitPoint;
    for (int i = 1; i <= 10; i++) {
        thumbnailPickerView.frame = CGRectMake(0, 0, i*150, 50);
        [thumbnailPickerView layoutSubviews];
        
        subviews = contentView.subviews;
        hitPoint = CGPointMake(0, 0);
        
        __block UIView *subview = nil;
        [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj pointInside:[obj convertPoint:hitPoint fromView:contentView] withEvent:nil]) {
                subview = obj;
                *stop = YES;
            }
        }];
        
        STAssertTrue([subview isKindOfClass:[UIImageView class]], @"subview at %d should be a UIImageView (is %@)", i, [subview class]);
        
        // Now we can't really check for the image since image loading is asynchronous
        // instead we're checking subview tag, that should correspond to image index in datasource
        STAssertEquals(subview.tag-THUMB_TAG_OFFSET, 0, @"subview should present first (index 0) data source image");
    }
}

- (void)testLastSubviewContainsLastDataSourceImage
{
    thumbnailPickerView.frame = CGRectMake(0, 0, 200, 50);
    DataSource *dataSource = [[DataSource alloc] init];
    dataSource.numberOfImages = 50;
    
    thumbnailPickerView.dataSource = dataSource;
    [thumbnailPickerView reloadData];
    
    UIView *contentView = [thumbnailPickerView performSelector:@selector(contentView)];
    
    NSArray *subviews = nil;
    CGPoint hitPoint;
    for (int i = 1; i <= 10; i++) {
        thumbnailPickerView.frame = CGRectMake(0, 0, i*150, 50);
        [thumbnailPickerView layoutSubviews];

        subviews = contentView.subviews;
        hitPoint = CGPointMake(contentView.bounds.size.width-1, 0);

        __block UIView *subview = nil;
        [subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj pointInside:[obj convertPoint:hitPoint fromView:contentView] withEvent:nil]) {
                subview = obj;
                *stop = YES;
            }
        }];
        
        STAssertTrue([subview isKindOfClass:[UIImageView class]], @"subview at %d should be a UIImageView (is %@)", i, [subview class]);
        
        // Now we can't really check for the image since image loading is asynchronous
        // instead we're checking subview tag, that should correspond to image index in datasource
        NSInteger lastThumbnailIndex = [thumbnailPickerView.dataSource numberOfImagesForThumbnailPickerView:thumbnailPickerView] - 1;
        STAssertEquals(subview.tag-THUMB_TAG_OFFSET, lastThumbnailIndex, @"subview should present last (index %d) data source image", lastThumbnailIndex);
    }
}


@end
