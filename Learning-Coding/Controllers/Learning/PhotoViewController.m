//
//  PhotoViewController.m
//  Learning-Coding
//
//  Created by 肖许 on 2016/11/3.
//  Copyright © 2016年 xiaoxu. All rights reserved.
//

#import "PhotoViewController.h"
#import "NsMedia.h"
#import "CategoryMedia.h"

@interface PhotoViewController ()

@end

static NSString *groupName = nil;

@implementation PhotoViewController
{
    ALAssetsLibrary  *library;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupSubview];
    [self loadVideoAssets];
}

-(void)setupSubview
{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreen_Width - 100)/2, 20, 100, 30)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissPhotoOld) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

-(void)dismissPhotoOld
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) loadVideoAssets
{
    
//    albumReadLock = [[NSConditionLock alloc] initWithCondition:WDASSETURL_PENDINGREADS];
    
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

    };
//    NSLog(@"\n照片获取权限返回yes or no \n");
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
                
                NSLog(@"urlstr %@ | fileNameTmp %@",urlstr,fileNameTmp);
                
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
            
        }
        
        if (group!=nil) {
            NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
            NSString *g1=[g substringFromIndex:16 ] ;
            NSArray *arr=[g1 componentsSeparatedByString:@","];
            groupName = [[arr objectAtIndex:0] substringFromIndex:5];
            groupName = [groupName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
            
            NSLog(@"group %@",group);
            NSLog(@"groupName %@",groupName);
//            CategoryMedia *childCatePhoto = [[CategoryMedia alloc] initWithKey:[NSString stringWithFormat:@"ROOT*PHOTO*%@",groupName] withName:groupName withUrl:nil withMediaType:@"PHOTO"];
//            
//            childCatePhoto.isDir = YES;
//            [albumTreeArr addObject:childCatePhoto];
//            [childCatePhoto release];
//            
//            CategoryMedia *childCateVideo = [[CategoryMedia alloc] initWithKey:[NSString stringWithFormat:@"ROOT*VIDEO*%@",groupName] withName:groupName withUrl:nil withMediaType:@"VIDEO"];
//            
//            childCateVideo.isDir = YES;
//            [albumTreeArr addObject:childCateVideo];
//            [childCateVideo release];
            
            [group enumerateAssetsUsingBlock:groupEnumerAtion];
        }
    };
    
    library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:libraryGroupsEnumeration
                         failureBlock:failureblock];


//    [self addItems:albumTreeArr];
//    [self.allMediaList addObjectsFromArray:albumTreeArr];
    
    NSLog(@"\n照片获取权限返回yes or no \n");
    return YES;
}


@end
