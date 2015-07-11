//
//  LFCGzipUtility.h
//  SKATiledMap
//
//  Modified version of Clint Harris' (www.clintharris.net) implementation
//

#import <Foundation/Foundation.h>
#import "zlib.h"

@interface LFCGzipUtility : NSObject

+ (NSData *)gzipData:(NSData *)pUncompressedData; // Compression
+ (NSData *)ungzipData:(NSData *)compressedData;  // Decompression

@end
