//
//  ThumbnailPickerView.h
//  ThumbnailPickerView
//
//  Created by Dominik Kapusta on 11-12-20.
//  Copyright (c) 2011 Dominik Kapusta.
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

#import <UIKit/UIKit.h>

@class ThumbnailPickerView;

@protocol ThumbnailPickerViewDelegate <NSObject>
@optional
- (void)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView didSelectImageWithIndex:(NSUInteger)index;
@end


@protocol ThumbnailPickerViewDataSource <NSObject>
- (NSUInteger)numberOfImagesForThumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView;
- (UIImage *)thumbnailPickerView:(ThumbnailPickerView *)thumbnailPickerView imageAtIndex:(NSUInteger)index;
@end


@interface ThumbnailPickerView : UIControl

- (void)reloadData;
- (void)reloadThumbnailAtIndex:(NSUInteger)index;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

// NSNotFound if nothing is selected
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, weak) IBOutlet id<ThumbnailPickerViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<ThumbnailPickerViewDelegate> delegate;
@end
