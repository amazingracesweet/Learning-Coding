//
//  NsMedia.m
//  DLNA_IOS
//
//  Created by 王 震宇 on 12-11-27.
//  Copyright (c) 2012年 Neusoft. All rights reserved.
//

#import "NsMedia.h"
#import <AVFoundation/AVFoundation.h>
#import "Util.h"

@implementation NsMedia

@synthesize type=_type;
@synthesize size=_size;
@synthesize duration = _duration;
@synthesize albumTitle = _albumTitle;
@synthesize artist = _artist;

- (id)initWithKey:( NSString*) key withName:(NSString*)name withUrl:(NSString *)assetUrl withType:(NSString*)type withSize:(int)size withMediaType:(NSString*)mediaT withDuration:(int)dur
{
    self = [super initWithKey:key withName:name withUrl:assetUrl withMediaType:mediaT];
    if (self) {
        self.type=type;
        self.size=size;
        self.mediaType = mediaT;
        self.duration = dur;
    }
    return self;
}

- (NSString*)getFullName {
    NSString *cate = [super getFullName];
    NSString *full = [NSString stringWithFormat:@"%@%@.%@",cate,[self getName],self.type];
    return full;
}

-(UIImage*)thumbnailImage
{
//    if(thumbnailImage==nil){
//        return thumbnailImage;
//    }else{
//        return thumbnailImage;
//    }
    return thumbnailImage;

}

-(UIImage *)getImage
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    NSURL *url=[NSURL URLWithString:self.alassetUrl];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(145, 145);
    
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    return image;
}
-(NSString*)getFileName
{
    return [NSString stringWithFormat:@"%@.%@",self.name,self.type];
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


@end
