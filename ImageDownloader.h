//
//  ImageDownloader.h
//  ClassicPhotos
//
//  Created by user on 11.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoRecord.h"

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation
@property (nonatomic, assign) id <ImageDownloaderDelegate> delegate;

// 3
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) PhotoRecord *photoRecord;

// 4
- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate;
-(NSString *)cacheFilePath:(NSString *)fileName;

@end

@protocol ImageDownloaderDelegate <NSObject>

// 5
- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader;
@end
