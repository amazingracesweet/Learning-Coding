//
//  RootMedia.h
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryMedia.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define PICTURE_MEDIA @"picture"
#define VIDEO_MEDIA @"video"
#define AUDIO_MEDIA @"audio"

enum {
    WDASSETURL_PENDINGREADS = 1,
    WDASSETURL_ALLFINISHED = 0
};

@interface RootMedia : CategoryMedia
{
    //所有子结点
    NSMutableArray* _allMediaList;
    
    ALAssetsLibrary          *library;
    NSConditionLock          *albumReadLock;
    NSMutableArray* _pictureList;
    NSMutableArray* _videoList;
    NSMutableArray* _musicList;

//    id<MsEngineDelegate> _msEngineDelegate;
}
//@property (nonatomic,assign)  id<MsEngineDelegate> msEngineDelegate;

@property (nonatomic, retain) NSMutableArray *allMediaList;
-(NSMutableArray*)getChildItemListWithMediaType:(NSString *)typ;

-(NSMutableArray*)getMediaList:(NSString*)type;

-(BOOL)loadMusicAsets;
-(BOOL) loadVideoAssets;


@end
