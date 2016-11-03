//
//  AbstractMedia.h
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CategoryMedia;
@interface AbstractMedia : NSObject
{
    NSString* _key;//ROOT*A*AA
    NSString* _name;//1.mov
    CategoryMedia* _fatherCategory;//他所在父目录对象
    BOOL _isDir;
    //ALAssetRepresentation *_assetRep;
    NSString *_alassetUrl;
    NSData*  thumbnailData;
    UIImage* thumbnailImage;
    
    NSString *_mediaType; //VIDEO?AUDIO?PHOTO
    NSString*_assetId;//刘列专用
}
-(NSString*) getFatherKey;
/**
 * 返回这个子结点的全路径，便不是KEY，并且去掉ROOT(中间用“/"表示)
    audio/1.mp4
 */
-(NSString*) getFullName;

- (id)initWithKey:( NSString*) key withName:(NSString*)name withUrl:(NSString *)assetUrl withMediaType:(NSString*)type;
@property (nonatomic,retain) CategoryMedia* fatherCategory;
@property (nonatomic,retain) NSString* key;
@property (nonatomic,retain) NSString* name;
@property (nonatomic) BOOL isDir;;
@property (nonatomic, retain) NSString *alassetUrl;
@property (nonatomic,retain) NSData* thumbnailData;
@property (nonatomic,retain) UIImage* thumbnailImage;
@property (nonatomic, retain) NSString *mediaType;
@property (nonatomic, retain) NSString *assetId;

-(NSString*) getName;
/**
 * 创建缩略图。<br>
 */
-(NSData*) createThumbnailData;



@end
