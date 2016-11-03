//
//  NsMedia.h
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractMedia.h"
#import <AssetsLibrary/AssetsLibrary.h>
enum {
    WDASSETURL_PENDINGREADS1 = 1,
    WDASSETURL_ALLFINISHED1 = 0
};

@interface NsMedia : AbstractMedia
{
    NSString* _type;//mov,png...
    long long _size;
    int _duration;
    NSString *_albumTitle;//专辑
    NSString *_artist;//歌手
    
}

- (id)initWithKey:( NSString*) key withName:(NSString*)name withUrl:(NSString *)assetUrl withType:(NSString*)type withSize:(int)size withMediaType:(NSString*)mediaT withDuration:(int)dur;

@property (nonatomic,retain) NSString* type;
@property (nonatomic) long long size;
@property (nonatomic) int duration;
@property (nonatomic, retain) NSString *albumTitle;
@property (nonatomic, retain) NSString *artist;

-(NSData*) createThumbnailData;
//取得文件名子 1.mov
-(NSString*)getFileName;

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
