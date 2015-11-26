//
//  PhotoRecord.m
//  ClassicPhotos
//
//  Created by user on 11.09.15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "PhotoRecord.h"

@implementation PhotoRecord

-(BOOL)hasImage{
    return _image != nil;
}

-(BOOL)isFailed{
    return _failed;
}

@end
