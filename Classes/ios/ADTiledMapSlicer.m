//
//  ADTiledMapSlicer.m
//  ADTiledMapSlicer
//
//  Created by Dat Truong on 2014-06-07.
//  Copyright (c) 2014 Dat Truong. All rights reserved.
//

#import "ADTiledMapSlicer.h"
#import "UIImage+Scale.h"

#define TILE_SIZE (CGSize){512, 512}

typedef NS_ENUM(NSUInteger, MAP_SIZE){
    MAP_SIZE_SMALL = 11,
    MAP_SIZE_MEDIUM,
    MAP_SIZE_BIG
};

@implementation ADTiledMapSlicer

#pragma mark - Common

- (void)generateSlicesForMapImage:(UIImage *) mapImage
{
    [self prepareDirectories];
    for (NSUInteger i = MAP_SIZE_SMALL; i <= MAP_SIZE_BIG; i++) {
        [self saveTilesForMapSize:i forImage:mapImage];
    }
}

#pragma mark - Directory

- (void)prepareDirectories
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *creatingDirectoryErr;
    NSString *directoryPath;
    
    for (NSUInteger i = MAP_SIZE_SMALL; i <= MAP_SIZE_BIG; i++) {
        directoryPath = [self directoryForMapSize:i];
        [fileManager createDirectoryAtPath:directoryPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:&creatingDirectoryErr];
    }
}

- (NSString *) directoryForMapSize:(MAP_SIZE) mapSize
{
    NSString *directoryPath;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    directoryPath = [NSString stringWithFormat:@"%@/Maps/%lu", documentPath, mapSize];

    return directoryPath;
}

#pragma mark - Slicing

- (void)saveTilesOfSize:(CGSize)size
               forImage:(UIImage*)image
            toDirectory:(NSString*)directoryPath
            usingPrefix:(NSString*)prefix
{
    CGFloat cols = [image size].width / size.width;
    CGFloat rows = [image size].height / size.height;
    
    int fullColumns = floorf(cols);
    int fullRows = floorf(rows);
    
    CGFloat remainderWidth = [image size].width -
    (fullColumns * size.width);
    CGFloat remainderHeight = [image size].height -
    (fullRows * size.height);
    
    
    if (cols > fullColumns) fullColumns++;
    if (rows > fullRows) fullRows++;
    
    CGImageRef fullImage = [image CGImage];
    
    for (int y = 0; y < fullRows; ++y) {
        for (int x = 0; x < fullColumns; ++x) {
            CGSize tileSize = size;
            if (x + 1 == fullColumns && remainderWidth > 0) {
                // Last column
                tileSize.width = remainderWidth;
            }
            if (y + 1 == fullRows && remainderHeight > 0) {
                // Last row
                tileSize.height = remainderHeight;
            }
            
            CGImageRef tileImage = CGImageCreateWithImageInRect(fullImage,
                                                                (CGRect){{x*size.width, y*size.height},
                                                                    tileSize});
            NSData *imageData = UIImagePNGRepresentation([UIImage imageWithCGImage:tileImage]);
            
            CGImageRelease(tileImage);
            
            NSString *path = [NSString stringWithFormat:@"%@/%@%d_%d.png",
                              directoryPath, prefix, x, y];
            [imageData writeToFile:path atomically:NO];
        }
    }
}

- (BOOL)saveTilesForMapSize:(MAP_SIZE)mapSize
                   forImage:(UIImage*)image
{
    CGSize size = TILE_SIZE;
    
    switch (mapSize) {
        case MAP_SIZE_SMALL:
            image = [image imageScaledToQuarter];
            break;
        case MAP_SIZE_MEDIUM:
            image = [image imageScaledToHalf];
        case MAP_SIZE_BIG:
            break;
        default:
            return NO;
            break;
    }

    NSString *directoryPath;
    directoryPath = [self directoryForMapSize:mapSize];
    
    [self saveTilesOfSize:size forImage:image toDirectory:directoryPath usingPrefix:@""];
    
    return YES;
}

@end
