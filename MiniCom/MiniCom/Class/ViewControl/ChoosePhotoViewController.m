//
//  ChoosePhotoView.m
//  MiniCom
//
//  Created by wlp on 14-6-8.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "ChoosePhotoViewController.h"
#import "NavView.h"

@implementation ChoosePhotoViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [Common addImageName:@"square_background.png" onView:self.view frame:kScreen_Frame];
        
        
        float wh = kScreen_Width * 0.3;
        float y = (kScreen_Height - wh) / 2;
        float xOffset = 20;
        float x1 = kScreen_Width / 2 - wh - xOffset;
        float x2 = kScreen_Width / 2 + xOffset;

        CGRect frameLeft = CGRectMake(x1, y, wh, wh);
        CGRect frameRight = CGRectMake(x2, y, wh, wh);
        
        _lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lbtn.frame = frameLeft;
        _lbtn.tag = 100;
        [_lbtn setBackgroundImage:[UIImage imageNamed:@"release_camera.png"] forState:UIControlStateNormal];
        [_lbtn addTarget:self action:@selector(selectCamera) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_lbtn];
        
        _rbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rbtn.frame = frameRight;
        _rbtn.tag = 200;
        [_rbtn setBackgroundImage:[UIImage imageNamed:@"release_local.png"] forState:UIControlStateNormal];
        [_rbtn addTarget:self action:@selector(selectLocal) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rbtn];
        
        //nav
        NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
                                                title:@"返回"
                                             delegate:self
                                                  sel:@selector(navAction)];
        [self.view addSubview:nav];
    }
    return self;
}

- (void)navAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectCamera
{
    //self.hidden = YES;
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [self choosePhotoViewDelegate:UIImagePickerControllerSourceTypeCamera];
}

- (void)selectLocal
{
    //self.hidden = YES;
    
    //[self dismissViewControllerAnimated:YES completion:nil];

    [self choosePhotoViewDelegate:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)choosePhotoViewDelegate:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"no support");
    }
}


#pragma mark ImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"Cancle it");
    [picker dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    NSLog(@"info = %@",info);
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if([mediaType isEqualToString:@"public.image"])	//被选中的是图片
	{
        //获取照片实例
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
        NSString *fileName = [[NSString alloc] init];
        
        if ([info objectForKey:UIImagePickerControllerReferenceURL]) {
            fileName = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
            //ReferenceURL的类型为NSURL 无法直接使用  必须用absoluteString 转换，照相机返回的没有UIImagePickerControllerReferenceURL，会报错
            fileName = [self getFileName:fileName];
        }
        else
        {
            fileName = [self timeStampAsString];
        }
		
        NSUserDefaults *myDefault = [NSUserDefaults standardUserDefaults];
        [myDefault setValue:fileName forKey:@"fileName"];
		[self performSelector:@selector(saveImg:) withObject:image afterDelay:0.0];
	}
	else
	{
		NSLog(@"Error media type");
		return;
	}
}

-(NSString *)getFileName:(NSString *)fileName
{
	NSArray *temp = [fileName componentsSeparatedByString:@"&ext="];
	NSString *suffix = [temp lastObject];
	
	temp = [[temp objectAtIndex:0] componentsSeparatedByString:@"?id="];
	
	NSString *name = [temp lastObject];
	
	name = [name stringByAppendingFormat:@".%@",suffix];
	return name;
}

-(NSString *)timeStampAsString
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE-MMM-d"];
    NSString *locationString = [df stringFromDate:nowDate];
    return [locationString stringByAppendingFormat:@".png"];
}

-(void)saveImg:(UIImage *) image
{
	NSLog(@"Review Image");
	//_photoImageView.image = image;
    [self.delegate choosePhotoViewImage:image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
