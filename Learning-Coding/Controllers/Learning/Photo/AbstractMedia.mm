//
//  AbstractMedia.m
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import "AbstractMedia.h"

@implementation AbstractMedia

@synthesize fatherCategory=_fatherCategory;
@synthesize key=_key;
@synthesize name=_name;
@synthesize isDir = _isDir;
@synthesize alassetUrl = _alassetUrl;
@synthesize thumbnailData;
@synthesize thumbnailImage;
@synthesize mediaType = _mediaType;
@synthesize assetId=_assetId;


- (id)initWithKey:( NSString*) key withName:(NSString*)name withUrl:(NSString *)assetUrl withMediaType:(NSString*)type{
    self = [super init];
    if (self) {
        self.key=key;
        self.name=name;
        self.alassetUrl = assetUrl;
        self.mediaType = type;
    }
    return self;
}

-(NSString*) getFatherKey
{
    //域名*A*AA*AAA的父结点名:域名*A*AA
    NSString* fullDictateName=@"" ;
    NSArray* myarray =[_key componentsSeparatedByString:@"*"];
    for(int i=0;i<[myarray count]-1;i++){
        NSString* str=[myarray objectAtIndex:i];
        if ([fullDictateName isEqualToString:@""]) {
            fullDictateName=[NSString stringWithFormat:@"%@",str];
        }else{
            fullDictateName=[NSString stringWithFormat:@"%@*%@",fullDictateName,str];
            
        }
    }
    if ([fullDictateName isEqualToString:@""]) {
        fullDictateName=@"ROOT";
        //NSLog(@"fatherFullDictateName=%@",fullDictateName);
    }
    //
    return fullDictateName;
}

-(NSString*) getFullName
{
    NSMutableString* stringBuffer=[[NSMutableString alloc]initWithString:@""];
    BOOL hasFatherNode=YES;
    AbstractMedia* mediaTmp=self;
    while (hasFatherNode) {
        mediaTmp=(AbstractMedia*)mediaTmp.fatherCategory;
        if(mediaTmp!=nil){
            //NSLog(@"test.name=%@",mediaTmp.name);
            if ([mediaTmp.name length]>0) {
                //[stringBuffer appendString:[NSString stringWithFormat:@"%@",mediaTmp.name]];
                [stringBuffer insertString:[NSString stringWithFormat:@"%@/",mediaTmp.name] atIndex:0];
            }
        }else{
            hasFatherNode=NO;
        }
    }
    return stringBuffer;
}

-(NSString*) getName
{
    return self.name;
    //add by wufan 
}


@end
