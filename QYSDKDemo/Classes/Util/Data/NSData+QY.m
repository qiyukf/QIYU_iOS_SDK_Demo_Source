//
//  NSData+QY.m
//  YSFSDK
//
//  Created by amao on 8/27/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NSData+QY.h"
#import <CommonCrypto/CommonDigest.h>
#import <zlib.h>

static const NSUInteger ChunkSize = 16384;

@implementation NSData (YSF)
- (NSString *)qy_md5
{
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (CC_LONG)[self length], r);
    return  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
             r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

- (NSData *)qy_gzippedData
{
    return [self qy_gzippedDataWithCompressLevel:-1.0f];
}

- (NSData *)qy_gunzippedData
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        NSMutableData *data = [NSMutableData dataWithLength:(NSUInteger)([self length] * 1.5)];
        if (inflateInit2(&stream, 47) == Z_OK)
        {
            int status = Z_OK;
            while (status == Z_OK)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += [self length] / 2;
                }
                stream.next_out = (uint8_t *)[data mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([data length] - stream.total_out);
                status = inflate (&stream, Z_SYNC_FLUSH);
            }
            if (inflateEnd(&stream) == Z_OK)
            {
                if (status == Z_STREAM_END)
                {
                    data.length = stream.total_out;
                    return data;
                }
            }
        }
    }
    return nil;
}

- (NSData *)qy_gzippedDataWithCompressLevel:(float)level
{
    if ([self length])
    {
        z_stream stream;
        stream.zalloc = Z_NULL;
        stream.zfree = Z_NULL;
        stream.opaque = Z_NULL;
        stream.avail_in = (uint)[self length];
        stream.next_in = (Bytef *)[self bytes];
        stream.total_out = 0;
        stream.avail_out = 0;
        
        int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
        if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK)
        {
            NSMutableData *data = [NSMutableData dataWithLength:ChunkSize];
            while (stream.avail_out == 0)
            {
                if (stream.total_out >= [data length])
                {
                    data.length += ChunkSize;
                }
                stream.next_out = (uint8_t *)[data mutableBytes] + stream.total_out;
                stream.avail_out = (uInt)([data length] - stream.total_out);
                deflate(&stream, Z_FINISH);
            }
            deflateEnd(&stream);
            data.length = stream.total_out;
            return data;
        }
    }
    return nil;
    
}

@end
