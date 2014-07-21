//
//  MyInfoChangeViewController.m
//  MiniCom
//
//  Created by wlp on 14-5-26.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "MyInfoChangeViewController.h"
#import "MyInfoChangePasswordViewController.h"
#import "Common.h"
#import "NavView.h"
#import "BaseTitleView.h"
#import "UIImageView+WebCache.h"
#import "SaveAccountCtrView.h"
#import "PhotoControlView.h"
#import "AccountManager.h"
#import "AccountData.h"
#import "MyNetManager.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
//#import <AssetsLibrary/AssetsLibrary.h>

@interface MyInfoChangeViewController ()

@end

@implementation MyInfoChangeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    _cellText_Ary = @[@"修改个人资料", @"头像", @"名字", @"性别", @"手机", @"主要业务"];
    
    //bg
    [Common addImageName:@"background1.png" onView:self.view frame:[Common RectMakex:0 y:0 w:1.0 h:1.0 onSuperBounds:kScreen_Frame]];
    
    _bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgBtn.frame = kScreen_Frame;
    [_bgBtn addTarget:self action:@selector(hideKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bgBtn];
    
    //
    [self loadChangeInfoView];
    
    //control
    _ctrView = [[SaveAccountCtrView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame]];
    [self.view addSubview:_ctrView];
    _ctrView.delegate = self;
    
    //
    _photoControlView = [[PhotoControlView alloc] initWithFrame:[Common RectMakex:0 y:0.9 w:1.0 h:0.1 onSuperBounds:kScreen_Frame] delegate:self];
    [self.view addSubview:_photoControlView];
    _photoControlView.hidden = YES;
    
//    //nav
//    NavView *nav = [[NavView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:0.1 onSuperBounds:self.view.bounds]
//                                            title:@"返回"
//                                         delegate:self
//                                              sel:@selector(backAction)];
//    [self.view addSubview:nav];
}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadChangeInfoView
{
    _okFrame = [Common RectMakex:0.05 y:0.05 w:0.9 h:0.6 onSuperBounds:kScreen_Frame];
    _upFrame = [Common RectMakex:0.05 y:-0.1 w:0.9 h:0.6 onSuperBounds:kScreen_Frame];
    
    _infoView = [[UIView alloc] initWithFrame:_okFrame];
    [self.view addSubview:_infoView];
    
    [Common addImageName:@"button_background_click.png"
                  onView:_infoView
                   frame:_infoView.bounds];
    
    UITableView *table = [[UITableView alloc] initWithFrame:_infoView.bounds];
    table.contentSize = _infoView.bounds.size;
    [_infoView addSubview:table];
    table.backgroundColor = [UIColor clearColor];
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cellText_Ary count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [_cellText_Ary count] - 1) {
        return 88.0;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    
    if (indexPath.row == [_cellText_Ary count] - 1) {
        [Common addImageName:@"barometer.png" onView:cell frame:CGRectMake(10, cell.contentView.bounds.size.height * 2 - 1.0, tableView.bounds.size.width - 20, 1)];
    }else
    {
        [Common addImageName:@"barometer.png" onView:cell frame:CGRectMake(10, cell.contentView.bounds.size.height - 1.0, tableView.bounds.size.width - 20, 1)];
    }
    
    UILabel *titleLb = [[UILabel alloc] init];
    titleLb.frame = [Common RectMakex:0.02 y:0 w:0.38 h:1.0 onSuperBounds:cell.bounds];
    titleLb.text = [_cellText_Ary objectAtIndex:indexPath.row];
    titleLb.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:titleLb];

    switch (indexPath.row) {
        case 0:
        {
            UILabel *changePassLb = [[UILabel alloc] init];
            changePassLb.frame = [Common RectMakex:0.4 y:0 w:0.48 h:1.0 onSuperBounds:cell.bounds];
            changePassLb.text = @"修改密码";
            changePassLb.textColor = [UIColor whiteColor];
            changePassLb.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:changePassLb];
            
            _changePass_btn = [UIButton buttonWithType:UIButtonTypeCustom];
            _changePass_btn.frame = changePassLb.frame;
            [_changePass_btn addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_changePass_btn];

        }
            break;
        case 1:
        {
            float offset = 5;
            float wh = cell.bounds.size.height - offset * 2;
            CGRect iframe = CGRectMake(tableView.bounds.size.width - wh - offset, offset, wh, wh);
            _icon_imgV = [Common initImageName:@"holding.png" onView:cell.contentView frame:iframe];
            [_icon_imgV setImageWithURL:[Common getUrlWithImageName:self.account.head] placeholderImage:[Common getDefaultAccountIcon]];

        }
            break;
        case 2:
        {
            _username_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.2 y:0 w:0.68 h:1.0 onSuperBounds:cell.bounds]];
            _username_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
            _username_tf.borderStyle = UITextBorderStyleNone;
            _username_tf.textAlignment = NSTextAlignmentRight;
            _username_tf.text = self.account.nickName;
            _username_tf.delegate = self;
            _username_tf.returnKeyType = UIReturnKeyDone;
             //_username_tf.keyboardType = UIKeyboardTypeNumberPad;
            _username_tf.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:_username_tf];
        }
            break;
        case 3:
        {
            _sex_lb = [[UILabel alloc] init];
            _sex_lb.frame = [Common RectMakex:0.4 y:0 w:0.48 h:1.0 onSuperBounds:cell.bounds];
            _sex_lb.text = self.account.sex;
            _sex_lb.textColor = [UIColor whiteColor];
            //passLb.backgroundColor = [UIColor redColor];
            _sex_lb.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:_sex_lb];
        }
            break;
        case 4:
        {
            _phone_tf = [[UITextField alloc] initWithFrame:[Common RectMakex:0.4 y:0 w:0.48 h:1.0 onSuperBounds:cell.bounds]];
            _phone_tf.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
            _phone_tf.borderStyle = UITextBorderStyleNone;
            _phone_tf.textAlignment = NSTextAlignmentRight;
            _phone_tf.text = self.account.phone;
            _phone_tf.delegate = self;
            _phone_tf.returnKeyType = UIReturnKeyDone;
            _phone_tf.keyboardType = UIKeyboardTypeNumberPad;
            _phone_tf.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:_phone_tf];
            
            _phone_tf.enabled = NO;
        }
            break;
        case 5:
        {
            _buss_tv = [[UITextView alloc] init];
            _buss_tv.frame = [Common RectMakex:0.3 y:0 w:0.58 h:2.0 onSuperBounds:cell.bounds];
            _buss_tv.text = self.account.mainBusiness;
            _buss_tv.textColor = [UIColor whiteColor];
            _buss_tv.backgroundColor = [UIColor clearColor];
            _buss_tv.delegate = self;
            [cell.contentView addSubview:_buss_tv];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hideKeyboard];
    
    if (indexPath.row == 1) {
        [self setPhotoViewShow:YES];
    }
    if (indexPath.row == 3) {
        if ([_sex_lb.text isEqualToString:@"男"]) {
            _sex_lb.text = @"女";
        }
        else
        {
            _sex_lb.text = @"男";
        }
    }
}

- (void)hideKeyboard
{
    [self setPhotoViewShow:NO];

    [_username_tf resignFirstResponder];
    [_phone_tf resignFirstResponder];
    [_buss_tv resignFirstResponder];
}

- (void)setPhotoViewShow:(BOOL)show
{
    _photoControlView.hidden = !show;
    _ctrView.hidden = show;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{    
    if ([_username_tf isFirstResponder]) {
        return;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _infoView.frame = _upFrame;
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.4 animations:^{
        _infoView.frame = _upFrame;
    }];
}

- (void)keyboardWillHide:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        _infoView.frame = _okFrame;
    }];
}

//
- (void)changePassword
{
    [self hideKeyboard];

    MyInfoChangePasswordViewController *myInfoChangePassVC = [[MyInfoChangePasswordViewController alloc] init];
    //myInfoVC.delegate = self;
    [self presentViewController:myInfoChangePassVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark save control

- (void)delegateSave
{
    NSLog(@"delegateSave");
    //上传头像
    NSString *newImageFileName = @"";
    if (self.isIconChange) {
        NSData *data = [Common scaleAndTransImage:_icon_imgV.image];
        newImageFileName = [Common getFileNameResouceData:data type:@"jpg"];
        [[MyNetManager SharedInstance] reqestUploadResouceData:data name:newImageFileName];
    }

    //修改个人资料
    NSString *nickName = _username_tf.text;
    NSString *sex = _sex_lb.text;
    NSString *mainBusiness = _buss_tv.text;
    NSString *head = [AccountManager SharedInstance].userInfoData.head;
    if (self.isIconChange) {
        head = newImageFileName;
    }

    NSString *phone = [AccountManager SharedInstance].userInfoData.phone;
    NSString *userBackground = [AccountManager SharedInstance].userInfoData.userBackground;
    NSString *password = [AccountManager SharedInstance].password;

    NSDictionary *accountDic = @{@"phone":phone,
                                 @"nickName":nickName,
                                 @"sex":sex,
                                 @"mainBusiness":mainBusiness,
                                 @"head":head,
                                 @"userBackground":userBackground,
                                 @"password":password,};
    NSString *accountStr = [accountDic JSONString];
    
    NSString *oldpassword = @"";
    NSDictionary *dic_params = @{@"oldpassword":oldpassword,
                                 @"account":accountStr};
    Params4Http *params = [[Params4Http alloc] initWithUrl:URL_account_modify
                                                    params:dic_params
                                                       tag:0
                                                   needHud:YES
                                                   hudText:@""
                                                 needLogin:YES];
    MyHttpRequest *myHttp = [[MyHttpRequest alloc] init];
    [myHttp startRequest:params
               hudOnView:self.view
                delegate:self];
}

- (void)isSuccessEquals:(RequestResult *)result
{
    //获取信息
    if (result.tag == 0) {
        NSDictionary *dic = result.myData;
        NSString *response = [dic valueForKey:ResponseMessKey];
        if ([response isEqualToString:@"修改用户信息成功"]) {
            NSLog(@"修改用户信息成功成功");
        }
        else if([response isEqualToString:@"修改用户信息成功失败"])
        {
            NSString *error = [dic valueForKey:@"失败原因"];
            [Common alert4error:error tag:0 delegate:nil];
        }
    }
}

- (void)delegateCancel
{
    [self backAction];
}

#pragma mark -
#pragma mark Change Photo

- (void)photoCtrViewClickedButtonAtIndex:(int)tag
{
    switch (tag) {
        case 0:
            NSLog(@"从照片");
            [self selectPhotoType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            NSLog(@"从相机");
            [self selectPhotoType:UIImagePickerControllerSourceTypeCamera];
            break;
        default:
            break;
    }
    //
    [self setPhotoViewShow:NO];
}

- (void)selectPhotoType:(UIImagePickerControllerSourceType)sourceType
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	NSLog(@"Cancle it");
    [picker dismissViewControllerAnimated:YES completion:nil];
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
	_icon_imgV.image = image;
    
    self.isIconChange = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
