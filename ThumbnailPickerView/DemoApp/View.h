//
//  View.h
//  ThumbnailPickerView
//
//  Created by Dominik Kapusta on 12-01-18.
//  Copyright (c) 2012 Dominik Kapusta.
//

#import <UIKit/UIKit.h>

@interface View : UIView

@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UIView *infoLabel;

@end
