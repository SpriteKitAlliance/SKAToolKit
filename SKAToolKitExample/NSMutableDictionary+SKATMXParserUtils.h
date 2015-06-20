//
//  NSMutableDictionary+SKATMXParserUtils.h
//  SKAToolKitExample
//
//  Created by Home on 6/16/15.
//  Copyright (c) 2015 Sprite Kit Alliance. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kBase64;
extern NSString * const kCompression;
extern NSString * const kData;
extern NSString * const kDrawOrder;
extern NSString * const kEncoding;
extern NSString * const kHeight;
extern NSString * const kId;
extern NSString * const kImage;
extern NSString * const kImageHeight;
extern NSString * const kImageWidth;
extern NSString * const kLayer;
extern NSString * const kLayers;
extern NSString * const kMap;
extern NSString * const kMargin;
extern NSString * const kName;
extern NSString * const kObject;
extern NSString * const kObjectGroup;
extern NSString * const kObjects;
extern NSString * const kOpacity;
extern NSString * const kOrientation;
extern NSString * const kProperties;
extern NSString * const kProperty;
extern NSString * const kRenderOrder;
extern NSString * const kRotation;
extern NSString * const kSource;
extern NSString * const kSpacing;
extern NSString * const kTile;
extern NSString * const kTileHeight;
extern NSString * const kTileLayer;
extern NSString * const kTileProperties;
extern NSString * const kTileset;
extern NSString * const kTilesets;
extern NSString * const kTileWidth;
extern NSString * const kTopDown;
extern NSString * const kType;
extern NSString * const kValue;
extern NSString * const kVersion;
extern NSString * const kVisible;
extern NSString * const kWidth;
extern NSString * const kX;
extern NSString * const kY;
extern NSString * const kZlib;

@interface NSMutableDictionary (SKATMXParserUtils)

- (void)cleanseMap;
- (void)cleanseTileset;
- (void)cleanseLayer;
- (void)cleanseObjectGroup;
- (void)cleanseObject;

@end
