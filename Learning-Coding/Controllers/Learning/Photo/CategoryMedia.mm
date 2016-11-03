//
//  CategoryMedia.m
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import "CategoryMedia.h"

@implementation CategoryMedia
@synthesize itemArray=_itemArray;

- (id)initWithKey:( NSString*) key withName:(NSString*)name withUrl:(NSString *)assetUrl withMediaType:(NSString *)type{
    self = [super initWithKey:key withName:name withUrl:assetUrl withMediaType:type];
    if (self) {
        _itemArray=[[NSMutableArray alloc]initWithCapacity:5];
    }
    return self;
}

-(NSData*) createThumbnailData {
    UIImage *img = [UIImage imageNamed:@"folderImg.png"];
    self.thumbnailImage=img;
    
    NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
    self.thumbnailData=dataObj;
    return self.thumbnailData;
}

/**
 * 增加一个任意指令。<br>
 *
 * @param dictate 任意指令
 */
-(void) addItem:(AbstractMedia*) media
{
    if ([self.itemArray containsObject:media]) {
        return ;
    }
    //NSLog(@"media.key---%@",media.key);
    [self.itemArray addObject:media];
    //设置任意子指令的父指令为当前类
    media.fatherCategory = self ;
}


/**
 * 把一个指令的集合自动增加到各个目录指令下。<br>
 *
 * @param dictateList 指令的集合
 */
-( void)addItems: (NSMutableArray *)itemViewArray {
    
    for (int i=0; i<[itemViewArray count]; i++) {
        AbstractMedia* itemVIew= [itemViewArray objectAtIndex:i];
        NSString * fatherKey=[itemVIew getFatherKey ] ;
        if ([fatherKey isEqualToString:self.key]) {
            //把任一一个指令增加到当前目录指令下
            //NSLog(@"fatherKey=%@",fatherKey);
            [self addItem:itemVIew];
            //如杲任一一个指令是目录指令
            if ([itemVIew isKindOfClass:[CategoryMedia class]]) {
                CategoryMedia* catalogItem = (CategoryMedia*) itemVIew;
                //执行递归操作.
                [catalogItem addItems:itemViewArray];
            }
        }
    }
}

-(NSMutableArray*)getCurrentChildItemList
{
    return self.itemArray ;
}

-(NSMutableArray*)findMediaChildItemList:(NSString*) key{
    CategoryMedia* media=(CategoryMedia*)[self findChildMediaWithKey:key];
    if(media!=nil){
        return [media getCurrentChildItemList];
    }
    return [[NSMutableArray alloc]initWithCapacity:0];
}

-(AbstractMedia*) findChildMediaWithKey:(NSString*) key{
    for (int i=0; i<[self.itemArray count]; i++) {
        AbstractMedia* itemVIewTmp= [self.itemArray objectAtIndex:i];
        //如杲任一一个指令是目录指令
        if ([itemVIewTmp.key isEqualToString:key]) {
            return itemVIewTmp;
        }
        
        if ([itemVIewTmp isKindOfClass:[CategoryMedia class]]) {
            CategoryMedia* catalogItem = (CategoryMedia*) itemVIewTmp;
            //执行递归操作.            
            AbstractMedia* findMedia=  [catalogItem findChildMediaWithKey:key];
            if(findMedia!=nil){
                return findMedia;
            }
        }
    }

    return nil;
}

-(AbstractMedia*) findChildMediaWithUrlPath:(NSString*) path withFileName:(NSString*)fileName
{
    CategoryMedia *media=self;
    NSArray* nameArray =[path componentsSeparatedByString:@"/"];
    for(int i=0;i<[nameArray count];i++){
        NSString* nameTmp=[nameArray objectAtIndex:i];
        media = [media findCategoryMediaWithKName:nameTmp];
        
    }
    media=[media findCategoryMediaWithKName:fileName];
    return media;
}

-(CategoryMedia*) findCategoryMediaWithKName:(NSString*)name
{
    for (int i=0; i<[self.itemArray count]; i++) {
        AbstractMedia* itemVIew= [self.itemArray objectAtIndex:i];
        if ([name isEqualToString:[itemVIew getName]]) {
            return (CategoryMedia*)itemVIew;
        }
    }
    return nil;
}

-(NSMutableArray*)getChildItemListWithKey:(NSString*)key
{
    return nil;
}

- (NSString*)getFullName {
    NSString *cate = [super getFullName];
    //NSLog(@"cate %@",cate);
    //NSLog(@"self.name %@",self.name);
    NSString *full = [NSString stringWithFormat:@"%@%@",[cate length]>0?[NSString stringWithFormat:@"%@",cate]:@"",self.name];
    //NSLog(@"full %@",full);
    return full;
}
//取得当前目录 下指定的大类型 ：（music,video,picture）
-(NSMutableArray*)getChildItemListWithMediaType:(NSString *)typ
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<[self.itemArray count]; i++) {
        
        AbstractMedia* itemVIew= [self.itemArray objectAtIndex:i];
        if([itemVIew isKindOfClass:[NsMedia class]]){
            NsMedia *itemVIew1=(NsMedia*)itemVIew;
            BOOL flag= YES;
            if (flag){
                [list  addObject:itemVIew1];
            }
        }
    }
    return list;

}


//new wang.zhy,取得当前下面的所有真实媒体，包含子文件夹的下的内容，但是不是含文件夹

-(NSMutableArray*)getChildALLItemList
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<[self.itemArray count]; i++) {
        
        AbstractMedia* itemView= [self.itemArray objectAtIndex:i];
        if([itemView isKindOfClass:[NsMedia class]]){
            [list  addObject:itemView];
        }else if([itemView isKindOfClass:[CategoryMedia class]]){
            CategoryMedia *cateMedia=(CategoryMedia*)itemView;
            NSMutableArray *listTmp=[cateMedia getChildALLItemList];
            [list addObjectsFromArray:listTmp];
        }
    }
    return list;
    
}

-(NSMutableArray*)getCategoryMediaList
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<[self.itemArray count]; i++) {
        AbstractMedia* itemVIew= [self.itemArray objectAtIndex:i];
        if([itemVIew isKindOfClass:[CategoryMedia class]]){
            [list  addObject:itemVIew];
            //[itemVIew release];
        }
    }
    return list;
}
-(NSMutableArray*)getNSMediaList
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<[self.itemArray count]; i++) {
        AbstractMedia* itemVIew= [self.itemArray objectAtIndex:i];
        if([itemVIew isKindOfClass:[NsMedia class]]){
            [list  addObject:itemVIew];
            //[itemVIew release];
        }
    }
    return list;
}

/**
 * 取得本目录下所有的真实的媒体文件，包含他下面的子文件夹。<br>
 */
-(NSMutableArray*)getAllNsMediaList
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<[self.itemArray count]; i++) {
        AbstractMedia* itemVIew= [self.itemArray objectAtIndex:i];
        if([itemVIew isKindOfClass:[NsMedia class]]){
            [list  addObject:itemVIew];
            //[itemVIew release];
        }else if([itemVIew isKindOfClass:[CategoryMedia class]]){
            CategoryMedia *categorItem=(CategoryMedia*)itemVIew;
            NSMutableArray *childList=[categorItem getAllNsMediaList];
            [list addObjectsFromArray:childList];
        }
    }
    return list;

}





-(NSMutableArray*)findMediaItemListWithName:(NSString*)name
{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:5];
    for (int i=0; i<[self.itemArray count]; i++) {
        AbstractMedia* itemView= [self.itemArray objectAtIndex:i];
        NSString* nameOri=[itemView.name uppercaseString];
        NSString* searchName=[name uppercaseString];
        NSRange range1 = [nameOri rangeOfString:searchName];
        if(range1.length >0){
            [list addObject:itemView];
        }
        if([itemView isKindOfClass:[CategoryMedia class]]){
            CategoryMedia *categorItem=(CategoryMedia*)itemView;
            NSMutableArray *childList=[categorItem findMediaItemListWithName:name];
            [list addObjectsFromArray:childList];
        }
    }
    return list;
}


@end
