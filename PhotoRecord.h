//
//  PhotoRecord.h
//  ClassicPhotos
//
//  Created by user on 11.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoRecord : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, readonly) BOOL hasImage;
@property (nonatomic, getter=isFailed) BOOL failed;
@end
