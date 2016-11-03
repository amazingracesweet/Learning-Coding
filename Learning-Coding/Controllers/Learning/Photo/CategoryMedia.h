//
//  CategoryMedia.h
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractMedia.h"
#import "NsMedia.h"
#import "Util.h"

@interface CategoryMedia : AbstractMedia
{
    NSMutableArray* _itemArray;
    
}
@property (nonatomic,retain) NSMutableArray* itemArray;

-(NSMutableArray*)getCurrentChildItemList;
-(void) addItem:(AbstractMedia*) media;
-( void)addItems: (NSMutableArray *)itemViewArray;
-(NSMutableArray*)getChildItemListWithKey:(NSString*)key;
-(AbstractMedia*) findChildMediaWithKey:(NSString*) key;
-(CategoryMedia*) findCategoryMediaWithKName:(NSString*)name;
-(AbstractMedia*) findChildMediaWithUrlPath:(NSString*)path withFileName:(NSString*)fileName;
-(NSMutableArray*)getChildItemListWithMediaType:(NSString *)typ;
/**
 * 取得本目录下所有的真实的媒体文件，包含他下面的子文件夹。<br>
 */
-(NSMutableArray*)getAllNsMediaList;



-(NSMutableArray*)getChildALLItemList;

@end
