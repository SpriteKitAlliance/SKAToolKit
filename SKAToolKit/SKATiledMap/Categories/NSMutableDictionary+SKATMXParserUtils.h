//
//  NSMutableDictionary+SKATMXParserUtils.h
//  SKAToolKitExample
//
//  Copyright (c) 2015 Sprite Kit Alliance
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

extern NSString *const kBase64;
extern NSString *const kCompression;
extern NSString *const kData;
extern NSString *const kDrawOrder;
extern NSString *const kEncoding;
extern NSString *const kHeight;
extern NSString *const kId;
extern NSString *const kImage;
extern NSString *const kImageHeight;
extern NSString *const kImageWidth;
extern NSString *const kLayer;
extern NSString *const kLayers;
extern NSString *const kMap;
extern NSString *const kMargin;
extern NSString *const kName;
extern NSString *const kObject;
extern NSString *const kObjectGroup;
extern NSString *const kObjects;
extern NSString *const kOpacity;
extern NSString *const kOrientation;
extern NSString *const kProperties;
extern NSString *const kProperty;
extern NSString *const kRenderOrder;
extern NSString *const kRotation;
extern NSString *const kSource;
extern NSString *const kSpacing;
extern NSString *const kTile;
extern NSString *const kTileHeight;
extern NSString *const kTileLayer;
extern NSString *const kTileProperties;
extern NSString *const kTiles;
extern NSString *const kTileset;
extern NSString *const kTilesets;
extern NSString *const kTileWidth;
extern NSString *const kTopDown;
extern NSString *const kType;
extern NSString *const kValue;
extern NSString *const kVersion;
extern NSString *const kVisible;
extern NSString *const kWidth;
extern NSString *const kX;
extern NSString *const kY;
extern NSString *const kZlib;

@interface NSMutableDictionary (SKATMXParserUtils)

- (void)cleanseMap;
- (void)cleanseTileset;
- (void)cleanseLayer;
- (void)cleanseObjectGroup;
- (void)cleanseObject;

@end
