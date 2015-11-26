//
//  LIstViewController.h
//  ClassicPhotos
//
//  Created by user on 11.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoRecord.h"
#import "PendingOperations.h"
#import "ImageDownloader.h"

@interface ListViewController : UITableViewController <ImageDownloaderDelegate>

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) PendingOperations *pendingOperations;
@end
