//
//  RootMedia.m
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import "RootMedia.h"

static NSString *groupName = nil;

@implementation RootMedia
@synthesize allMediaList=_allMediaList;
//@synthesize msEngineDelegate=_msEngineDelegate;
- (id)init{
    self = [super initWithKey:@"ROOT" withName:@"" withUrl:nil withMediaType:nil];
    if (self) {
        self.isDir = YES;
        self.allMediaList=[[NSMutableArray alloc]initWithCapacity:3];
    }
    return self;
}


/**
 * 取得ROOT下的所有是目录的（取得的结果不需要树结构，全是平级的）。<br>
 */
-(NSMutableArray*)getCategoryMedia
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];

    for (int i=0; i<[self.allMediaList count]; i++) {
        AbstractMedia* itemVIew= [self.allMediaList objectAtIndex:i];
        if([itemVIew isKindOfClass:[CategoryMedia class]]){
            CategoryMedia* cateGory=(CategoryMedia*)itemVIew;
            if ([self hasNsMedia:cateGory]) {
                [list addObject:cateGory];
            }
            
        }
    }
    return list;
}

//取得当前目录 下指定的大类型 ：（music,video,picture）
-(NSMutableArray*)getChildItemListWithMediaType:(NSString *)typ
{
    NSString *key=@"";
    if ([typ isEqualToString:@"picture"]) {
        key=@"ROOT*PHOTO";
    }else if ([typ isEqualToString:@"video"]) {
        key=@"ROOT*VIDEO";
    }else if ([typ isEqualToString:@"audio"]) {
        key=@"ROOT*AUDIO";
    }
    CategoryMedia* cate=(CategoryMedia*)[self findChildMediaWithKey:key];
    return [cate getChildALLItemList];
    
}


/**
 * 判断这个目录下的所有子结点是否有为真实媒体，即不包含下一级目录。<br>
 */
-(BOOL)hasNsMedia:(CategoryMedia*)category
{
    for (int j=0; j<[category.itemArray count]; j++) {
        AbstractMedia* itemVIewTmp= [category.itemArray objectAtIndex:j];
        if([itemVIewTmp isKindOfClass:[NsMedia class]]){
            return YES;
        }
    }
    
    return NO;
}

- (NSString*)getFullName {
    return @"";
}

-(NSMutableArray*)getMediaList:(NSString*)type
{
    if ([type isEqualToString:PICTURE_MEDIA]) {
        if(_pictureList==nil){
            _pictureList=[self getChildItemListWithMediaType:type];
            _pictureList = [[NSMutableArray alloc]initWithArray:[[_pictureList reverseObjectEnumerator] allObjects]];
        }
        return _pictureList;
        
    }else if ([type isEqualToString:VIDEO_MEDIA]) {
        if(_videoList==nil){
            _videoList=[self getChildItemListWithMediaType:type];
            _videoList = [[NSMutableArray alloc]initWithArray:[[_videoList reverseObjectEnumerator] allObjects]];
        }
        return _videoList;
        
    }else if ([type isEqualToString:AUDIO_MEDIA]) {
        if(_musicList==nil){
            _musicList=[self getChildItemListWithMediaType:type];
            if (_musicList==nil) {
                //wang.zhy
                _musicList=[self getChildItemListWithMediaType:type];
            }
        }
        return _musicList;
    }
    return nil;
}

-(BOOL)loadMusicAsets
{
    //CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    
//    NSMutableArray *albumTreeArr = [[NSMutableArray alloc] init];
//    CategoryMedia *childMusic = [[CategoryMedia alloc] initWithKey:@"ROOT*AUDIO" withName:@"AUDIO" withUrl:nil withMediaType:@"AUDIO"];
//    childMusic.isDir = YES;
//    [albumTreeArr addObject:childMusic];
//
//    
//    //音乐库目录Tree
//    CategoryMedia *muCate = [[CategoryMedia alloc] initWithKey:@"ROOT*AUDIO*MusicLibrary" withName:@"MusicLibrary" withUrl:nil withMediaType:@"AUDIO"];
//    muCate.isDir = YES;
//    [albumTreeArr addObject:muCate];
//    
//    
//    MPMediaQuery *everything = [[[MPMediaQuery alloc] init] autorelease];
//    NSArray *itemsFromGenericQuery = [everything items];
//    NSLog(@"\n音乐权限，音乐库=%@\n",itemsFromGenericQuery);
//    for (MPMediaItem *song in itemsFromGenericQuery) {
//        
//        NSNumber *fileDur = [song valueForKey:MPMediaItemPropertyPlaybackDuration];//音乐时长
//        NSString *albumTitle = [song valueForKey:MPMediaItemPropertyAlbumTitle];
//        if ([albumTitle isEqualToString:@"(null)"] || [albumTitle rangeOfString:@"?"].length>0 || [albumTitle length] == 0 || albumTitle == nil) {
//            albumTitle = @"未知";
//        }
//        NSString *artist = [song valueForKey:MPMediaItemPropertyArtist];
//        if ([artist isEqualToString:@"(null)"] || [artist rangeOfString:@"?"].length>0 || [artist length] == 0 || artist == nil) {
//            artist = @"未知";
//        }
//        // MPMediaItem里有一个property叫MPMediaItemPropertyArtwork，具体用法如下：
//        MPMediaItemArtwork *artwork = [song valueForProperty: MPMediaItemPropertyArtwork];
//        UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(100, 100)];
//        
//        NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
//        
//            if ([songTitle isEqualToString:@"(null)"] || [songTitle rangeOfString:@"?"].length>0 || [songTitle length] == 0 || songTitle == nil) {
//                songTitle = @"未知";
//            }
//            NSURL *songURL = [song valueForProperty:MPMediaItemPropertyAssetURL];
//            NSString *urlStr = [NSString stringWithFormat:@"%@",songURL];
//            
//            
//            NSArray *arr = [urlStr componentsSeparatedByString:@"ipod-library://item/item."];
//            NSString *lastOb = [arr lastObject];
//            NSArray *arr2 = [lastOb componentsSeparatedByString:@"?id="];
//            /** add by xiaoxu **/
//            if(arr2.count < 2)
//            {
//                NSLog(@"invalid music continue");
//                continue;
//            }
//            NSString *type = [arr2 objectAtIndex:0];
//            NSString *mid = [arr2 objectAtIndex:1];
//        //qiuxiang 修改
//        if ([type compare:@"mp3" options:NSCaseInsensitiveSearch]==NSOrderedSame||[type compare:@"m4a" options:NSCaseInsensitiveSearch]==NSOrderedSame) {
//            NSMusicMedia *childMedia = [[NSMusicMedia alloc] initWithKey:[NSString stringWithFormat:@"ROOT*AUDIO*MusicLibrary*%@",mid] withName:songTitle withUrl:urlStr withType:type withSize:0 withThumbnail:artworkImage withMid:mid withDuration:[fileDur intValue] withAlbumTitle:albumTitle withArtist:artist];
//            childMedia.isDir = NO;
//            childMedia.assetId=mid;
//            
//            [albumTreeArr addObject:childMedia];
//            [childMedia release];
//        }
//        else
//        {
//
//        }
//        //qiuxiang
//    }
//    [self addItems:albumTreeArr];
//    [self.allMediaList addObjectsFromArray:albumTreeArr];
    
    
    return YES;
}

-(BOOL) loadVideoAssets
{
    //CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    albumReadLock = [[NSConditionLock alloc] initWithCondition:WDASSETURL_PENDINGREADS];
    
    NSMutableArray *albumTreeArr = [[NSMutableArray alloc] init];
    
    CategoryMedia *childPhoto = [[CategoryMedia alloc] initWithKey:@"ROOT*PHOTO" withName:@"PHOTO" withUrl:nil withMediaType:@"PHOTO"];
    childPhoto.isDir = YES;
    [albumTreeArr addObject:childPhoto];
    
    
    CategoryMedia *childVideo = [[CategoryMedia alloc] initWithKey:@"ROOT*VIDEO" withName:@"VIDEO" withUrl:nil withMediaType:@"VIDEO"];
    childVideo.isDir = YES;
    [albumTreeArr addObject:childVideo];
    
    
  
    
    ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
        NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
        }else{
            NSLog(@"相册访问失败.");
            
        }
//        NSLog(@"\ndelegetate=%@\n",[MsEngine getInstance].msEngineDelegate);
//        [[MsEngine getInstance].msEngineDelegate loadAssetFailed];
//        [MsEngine getInstance].isLoadSuccess = YES;
    };
    NSLog(@"\n照片获取权限返回yes or no \n");
    ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result!=NULL) {
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
//                long long fileSize = result.defaultRepresentation.size;//文件大小
                
                NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                
                NSArray *arr1 = [urlstr componentsSeparatedByString:@"?id="];
                NSArray *arr2 = [[arr1 objectAtIndex:1] componentsSeparatedByString:@"&"];
                NSString *m = [arr2 objectAtIndex:0];
                
                NSString *key = [NSString stringWithFormat:@"ROOT*PHOTO*%@*%@",groupName,m];
                
                NSArray *arr3 = [urlstr componentsSeparatedByString:@"&ext="];
                
                NSString *type = [arr3 objectAtIndex:1];
                NSString* fileNameTmp=result.defaultRepresentation.filename;
                
                {
                    NsMedia *childMedia = [[NsMedia alloc] initWithKey:key withName:[[fileNameTmp componentsSeparatedByString:@"."] objectAtIndex:0] withUrl:urlstr withType:type withSize:0 withMediaType:@"PHOTO" withDuration:0];
                    childMedia.isDir = NO;
                    childMedia.assetId=m;
                    
                    UIImage*image=[UIImage imageWithCGImage:result.thumbnail];
                    childMedia.thumbnailImage=image;
                    [albumTreeArr addObject:childMedia];
                    
                }
            }
            
            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo]) {
                NSNumber *fileDur = [result valueForProperty:ALAssetPropertyDuration];//视频时长
                long long fileSize = result.defaultRepresentation.size;//文件大小
                
                NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//视频的url
                NSArray *arr1 = [urlstr componentsSeparatedByString:@"?id="];
                NSArray *arr2 = [[arr1 objectAtIndex:1] componentsSeparatedByString:@"&"];
                NSString *m = [arr2 objectAtIndex:0];
                
                NSString *key = [NSString stringWithFormat:@"ROOT*VIDEO*%@*%@",groupName,m];
                
                NSArray *arr3 = [urlstr componentsSeparatedByString:@"&ext="];
                NSString *type = [arr3 objectAtIndex:1];
                NSString* fileNameTmp=result.defaultRepresentation.filename;
                
                {
                    NsMedia *childMedia = [[NsMedia alloc] initWithKey:key withName:[[fileNameTmp componentsSeparatedByString:@"."] objectAtIndex:0] withUrl:urlstr withType:type withSize:fileSize withMediaType:@"VIDEO" withDuration:[fileDur intValue]];
                    childMedia.isDir = NO;
                    childMedia.assetId=m;
                    UIImage*image=[UIImage imageWithCGImage:result.thumbnail];
                    childMedia.thumbnailImage=image;
                    [albumTreeArr addObject:childMedia];
                    
                }
            }
        }
    };
    
    
    ALAssetsLibraryGroupsEnumerationResultsBlock
    libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
        if (group == nil)
        {
            [albumReadLock lock];
            [albumReadLock unlockWithCondition:WDASSETURL_ALLFINISHED];
        }
        
        if (group!=nil) {
            NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
            NSString *g1=[g substringFromIndex:16 ] ;
            NSArray *arr=[g1 componentsSeparatedByString:@","];
            groupName = [[arr objectAtIndex:0] substringFromIndex:5];
            groupName = [groupName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            CategoryMedia *childCatePhoto = [[CategoryMedia alloc] initWithKey:[NSString stringWithFormat:@"ROOT*PHOTO*%@",groupName] withName:groupName withUrl:nil withMediaType:@"PHOTO"];
            
            childCatePhoto.isDir = YES;
            [albumTreeArr addObject:childCatePhoto];
            
            
            CategoryMedia *childCateVideo = [[CategoryMedia alloc] initWithKey:[NSString stringWithFormat:@"ROOT*VIDEO*%@",groupName] withName:groupName withUrl:nil withMediaType:@"VIDEO"];
            
            childCateVideo.isDir = YES;
            [albumTreeArr addObject:childCateVideo];

            
            [group enumerateAssetsUsingBlock:groupEnumerAtion];
        }
    };
    
    library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:libraryGroupsEnumeration
                         failureBlock:failureblock];
    
    [albumReadLock lockWhenCondition:WDASSETURL_ALLFINISHED];
    [albumReadLock unlock];
    
    // cleanup
    
    albumReadLock = nil;
   [self addItems:albumTreeArr];
    [self.allMediaList addObjectsFromArray:albumTreeArr];


    return YES;
}
@end
