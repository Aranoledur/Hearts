//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by user on 11.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) PhotoRecord *photoRecord;
@end

@implementation ImageDownloader

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        // 2
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.photoRecord = record;
    }
    return self;
}

#pragma mark -
#pragma mark - Downloading image

// 3
- (void)main {
    
    // 4
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        NSString* fullFilePath = [self cacheFilePath:self.photoRecord.fileName];
        
        UIImage* readyImage = [UIImage imageWithContentsOfFile:fullFilePath];
        if(readyImage){
            self.photoRecord.image = readyImage;
            
            if (self.isCancelled)
                return;
        }
        else {
            
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.photoRecord.URL];
            
            if (self.isCancelled) {
                imageData = nil;
                return;
            }
            
            NSError *error = nil;
            if(![imageData writeToFile:fullFilePath options:NSDataWritingAtomic error:&error]){
                NSLog(@"Write returned error: %@", [error localizedDescription]);
            }
            
            if(self.isCancelled){
                imageData = nil;
                return;
            }
            
            if (imageData) {
                UIImage *downloadedImage = [UIImage imageWithData:imageData];
                self.photoRecord.image = downloadedImage;
            }
            else {
                self.photoRecord.failed = YES;
            }
            
            imageData = nil;
            
            if (self.isCancelled)
                return;
        }
        
        // 5
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

-(NSString *)cacheFilePath:(NSString *)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    BOOL isDir = NO;
    NSError *error;
    if (! [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&isDir] && isDir == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    NSString *filePath =  [cachePath stringByAppendingPathComponent: fileName];
    return filePath;
}

@end
