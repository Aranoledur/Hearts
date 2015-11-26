//
//  PendingOperations.h
//  ClassicPhotos
//
//  Created by user on 11.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject
@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@end
