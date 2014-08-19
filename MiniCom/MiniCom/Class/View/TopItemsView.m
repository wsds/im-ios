//
//  BtnItemsView.m
//  MiniCom
//
//  Created by wlp on 14-5-21.
//  Copyright (c) 2014年 wanglipeng. All rights reserved.
//

#import "TopItemsView.h"
#import "Common.h"
#import "MyButton.h"

enum{
    E_square,
    E_group,
    E_own
};

//#define baseH 0.6
//#define subH 1.0 - baseH

#define TopH 0.2
#define SubH (1.0 - TopH) / 2

@implementation TopItemsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadBaseView];
        
        [self loadSubView];
    }
    return self;
}

- (void)loadBaseView
{
    //self.backgroundColor = [UIColor darkGrayColor];

    _baseView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:TopH w:1.0 h:SubH onSuperBounds:self.bounds]];
    _baseView.backgroundColor = [UIColor colorWithRed:0.14 green:0.16 blue:0.26 alpha:1.0];
    [self addSubview:_baseView];
    
    GBView=[[UIImageView alloc]init];
    GBView.frame=CGRectMake(17, 15, 30, 25);
    GBView.image=[UIImage imageNamed:@"square_release.png"];
    [_baseView addSubview:GBView];
    
    label=[[UILabel alloc]init];
    label.frame=CGRectMake(60, 15, 80, 25);
    label.text=@"亦庄站";
    label.textColor = [UIColor whiteColor];
    [_baseView addSubview:label];
    
    
    UIImageView *selectimg=[[UIImageView alloc]init];
    selectimg.frame = CGRectMake(label.frame.size.width - 8, label.frame.size.height - 8, 8, 8);
    selectimg.image=[UIImage imageNamed:@"selected_comment_icon.png"];
    [label addSubview:selectimg];

    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable:)];
    
    label.userInteractionEnabled=YES;
    tapGesture.numberOfTouchesRequired=1;
    [label addGestureRecognizer:tapGesture];
    
    UIImageView *SquareView=[[UIImageView alloc]init];
    SquareView.frame=CGRectMake(185, 15, 30, 25);
    SquareView.image=[UIImage imageNamed:@"square_icon_selected.png"];
    [_baseView addSubview:SquareView];
    
    UITapGestureRecognizer *SquaretapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SquareView:)];
    SquareView.userInteractionEnabled=YES;
    SquaretapGesture.numberOfTouchesRequired=1;
    [SquareView addGestureRecognizer:SquaretapGesture];
    
    
    UIImageView *GroupView=[[UIImageView alloc]init];
    GroupView.frame=CGRectMake(235, 15, 30, 25);
    GroupView.image=[UIImage imageNamed:@"group_icon.png"];
    [_baseView addSubview:GroupView];
    
    UITapGestureRecognizer *GrouptapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(GroupView:)];
    GroupView.userInteractionEnabled=YES;
    GrouptapGesture.numberOfTouchesRequired=1;
    [GroupView addGestureRecognizer:GrouptapGesture];

    UIImageView *LinkmanView=[[UIImageView alloc]init];
    LinkmanView.frame=CGRectMake(285, 15, 30, 25);
    LinkmanView.image=[UIImage imageNamed:@"person_icon.png"];
    [_baseView addSubview:LinkmanView];
    
    UITapGestureRecognizer *linktapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LinkView:)];
    LinkmanView.userInteractionEnabled=YES;
    linktapGesture.numberOfTouchesRequired=1;
    [LinkmanView addGestureRecognizer:linktapGesture];


    /*
    _titleAry = @[ @"广场", @"群组", @"我"];
    
    float www = 1.0 / [_titleAry count];

    for (int i = 0; i < [_titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.tag=i;
        btn.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        */
    /*btn2.frame = [Common RectMakex:(www * i)*1.5  y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        btn3.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        btn4.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
       */
    /*
        
            
            [btn setTitle:[_titleAry objectAtIndex:i] forState:UIControlStateNormal];
            [btn setSelectedImageModel:E_Sanjiao];
            
            
        }
         */
    /*
        [btn addTarget:self action:@selector(baseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(sub1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(sub2BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        
        [btn addTarget:self action:@selector(xxView:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
*/
       
    
         

        
}

-(void)SquareView:(UITapGestureRecognizer *)sender{
 

    NSLog(@"11111");
    
    
    
    joinView.hidden=YES;
    qrcodeView.hidden=YES;
    GBView.hidden=NO;
    newGrouplabel.text=label.text;
    personlabel.text=@"";
   
 
    
   

}
-(void)GroupView:(UITapGestureRecognizer *)sender{
    NSLog(@"22222");
    personlabel.text=@"";
    personlabel.hidden=YES;
    joinView=[[UIImageView alloc]init];
    joinView.frame=CGRectMake(17, 15, 30, 20);
    joinView.image=[UIImage imageNamed:@"gshare_group.png"];
    [_baseView addSubview:joinView];
    joinView.hidden=YES;
    GBView.image=joinView.image;
    
    label.hidden=YES;;
  
    joinView.hidden=YES;
    personlabel.text=@"";
    newGrouplabel=[[UILabel alloc]init];
    newGrouplabel.frame=CGRectMake(60, 15, 80, 25);
    newGrouplabel.text=@"新建群组";
    newGrouplabel.textColor=[UIColor whiteColor];
    [_baseView addSubview:newGrouplabel];
    
    UIImageView *selectimg=[[UIImageView alloc]init];
    selectimg.frame = CGRectMake(newGrouplabel.frame.size.width - 8, newGrouplabel.frame.size.height - 8, 8, 8);
    selectimg.image=[UIImage imageNamed:@"selected_comment_icon.png"];
    [newGrouplabel addSubview:selectimg];
    label.text=newGrouplabel.text;
    
    UITapGestureRecognizer *newtapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newonClick:)];
    
    newGrouplabel.userInteractionEnabled=YES;
    newtapGesture.numberOfTouchesRequired=1;
    [newGrouplabel addGestureRecognizer:newtapGesture];

    
    
    
}
-(void)LinkView:(UITapGestureRecognizer *)sender{

    NSLog(@"3333");
    
    view3.hidden=YES;
    label.text=@"";
    newGrouplabel.text=@"";
    newGrouplabel.hidden=YES;
    qrcodeView=[[UIImageView alloc]init];
    qrcodeView.frame=CGRectMake(17, 15, 25, 20);
    qrcodeView.image=[UIImage imageNamed:@"scanner.png"];
    [_baseView addSubview:qrcodeView];
    joinView.hidden=YES;
    GBView.hidden=YES;
    joinView.image=qrcodeView.image;
    
    
    personlabel=[[UILabel alloc]init];
    personlabel.frame=CGRectMake(60, 15, 80, 25);
    personlabel.text=@"罗阳";
    personlabel.textColor=[UIColor whiteColor];
    [_baseView addSubview:personlabel];
    //newGrouplabel.text=personlabel.text;
    UIImageView *selectimg=[[UIImageView alloc]init];
    selectimg.frame = CGRectMake(newGrouplabel.frame.size.width - 8, newGrouplabel.frame.size.height - 8, 8, 8);
    selectimg.image=[UIImage imageNamed:@"selected_comment_icon.png"];
    [personlabel addSubview:selectimg];
    //newGrouplabel.text=personlabel.text;
    
    
    
    
    
}
/*
-(void)xxView:(MyButton *)sender{

    NSLog(@"ccccc");
    label.text=@"";
    float www = 1.0 / [_titleAry count];
    UILabel  *label4=[[UILabel alloc]init];
    label4.frame=[Common RectMakex:www  y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
    label4.text=@"新建";
    label4.textColor=[UIColor whiteColor];
    [_baseView addSubview:label4];
    
    UITapGestureRecognizer *newtapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(newonClick:)];
    
    label4.userInteractionEnabled=YES;
    newtapGesture.numberOfTouchesRequired=1;
    [label4 addGestureRecognizer:newtapGesture];

    /*
    xxView=[[UIView  alloc]init];
    xxView.frame=CGRectMake(9, 90, 305, 300);
    xxView.backgroundColor=[UIColor clearColor];
    xxView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"background4.jpg"] ];
    [_baseView addSubview:xxView];
   //搜索好友
    UIView *searchFriendView=[[UIView  alloc]init];
    searchFriendView.frame=CGRectMake(1, 10, 304, 35);
    searchFriendView.backgroundColor=[UIColor grayColor];
    [xxView addSubview:searchFriendView];
   
    UIImageView *searchImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,20 , 20)];
    searchImg.image=[UIImage imageNamed:@"dialog_search.png"];
    [searchFriendView  addSubview:searchImg];
    
    UILabel * searchLabel=[[UILabel alloc]init];
    searchLabel.frame=CGRectMake(40, 10, 100, 20);
    searchLabel.text=@"搜索好友";
    searchLabel.textColor=[UIColor whiteColor];
    [searchFriendView addSubview:searchLabel];
    
    //新的好友
    
    UIView *newFriendView=[[UIView  alloc]init];
    newFriendView.frame=CGRectMake(0, 50, 304, 35);
    newFriendView.backgroundColor=[UIColor grayColor];
    [xxView addSubview:newFriendView];

    UIImageView *newImg=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,20 , 20)];
    newImg.image=[UIImage imageNamed:@"header.png"];
    [newFriendView addSubview:newImg];
    
    UILabel * newLabel=[[UILabel alloc]init];
    newLabel.frame=CGRectMake(40, 10, 100, 20);
    newLabel.text=@"新的好友";
    newLabel.textColor=[UIColor whiteColor];
    [newFriendView addSubview:newLabel];

    //默认分组
    UIView  *defaultGroupview=[[UIView  alloc]init];
    defaultGroupview.frame=CGRectMake(0, 90, 304, 210);
    defaultGroupview.backgroundColor=[UIColor grayColor];
    [xxView addSubview:defaultGroupview];
    
    UIImageView *newImg1=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,20 , 20)];
    newImg1.image=[UIImage imageNamed:@"header.png"];
    [defaultGroupview addSubview:newImg1];
    
    
    UILabel * defaultLabel=[[UILabel alloc]init];
    defaultLabel.frame=CGRectMake(40, 10, 100, 20);
    defaultLabel.text=@"默认分组(3)";
    defaultLabel.textColor=[UIColor whiteColor];
    [defaultGroupview addSubview:defaultLabel];
    
    UIView *lineView=[[UIView alloc]init];
    lineView.frame=CGRectMake(0, 40, 290, 1);
    lineView.backgroundColor=[UIColor whiteColor];
    [defaultGroupview addSubview:lineView];
    
    
    UIImageView *defaultimg1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 50,50, 50)];
    defaultimg1.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    defaultimg1.layer.cornerRadius = 25;
    defaultimg1.layer.masksToBounds = YES;
    [defaultGroupview addSubview:defaultimg1];

    UIImageView *defaultimg2=[[UIImageView alloc]initWithFrame:CGRectMake(75, 50,50, 50)];
    defaultimg2.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    defaultimg2.layer.cornerRadius = 25;
    defaultimg2.layer.masksToBounds = YES;
    [defaultGroupview addSubview:defaultimg2];
    
    
    UIImageView *defaultimg3=[[UIImageView alloc]initWithFrame:CGRectMake(135, 50,50, 50)];
    defaultimg3.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    defaultimg3.layer.cornerRadius = 25;
    defaultimg3.layer.masksToBounds = YES;
    [defaultGroupview addSubview:defaultimg3];
    
    UILabel *labelperson1=[[UILabel alloc]init];
    labelperson1.frame=CGRectMake(25, 101, 50, 20);
    labelperson1.text=@"152~";
    [labelperson1 setFont:[UIFont systemFontOfSize:13.0]];
    labelperson1.textColor=[UIColor whiteColor];
    [defaultGroupview addSubview:labelperson1];
    
    UILabel *labelperson2=[[UILabel alloc]init];
    labelperson2.frame=CGRectMake(80, 101, 50, 20);
    labelperson2.text=@"乔晓松";
    [labelperson2 setFont:[UIFont systemFontOfSize:13.0]];
    labelperson2.textColor=[UIColor whiteColor];
    [defaultGroupview addSubview:labelperson2];
    
    UILabel *labelperson3=[[UILabel alloc]init];
    labelperson3.frame=CGRectMake(145, 101, 50, 20);
    labelperson3.text=@"罗阳";
    [labelperson3 setFont:[UIFont systemFontOfSize:13.0]];
    labelperson3.textColor=[UIColor whiteColor];
    [defaultGroupview addSubview:labelperson3];
    */
    
    
//}

-(void)newonClick:(UITapGestureRecognizer *)sender{
    
    
    NSLog(@"-----");
    view3=[[UIView alloc]initWithFrame:CGRectMake(40, 80, 240, 350)];
    view3.backgroundColor = [UIColor whiteColor];
    view3.tag=1;
    view3.userInteractionEnabled=YES;
    [self.window addSubview:view3];
    
    
    UIButton *deletebtn1=[UIButton buttonWithType:UIButtonTypeCustom];
    
    deletebtn1.frame=CGRectMake(0, 0, 14, 14);
    deletebtn1.tag=101;
    [deletebtn1 setBackgroundImage:[UIImage imageNamed:@"input_clear.png"] forState:UIControlStateNormal];
    [deletebtn1 addTarget:self action:@selector(cancelbtn1:) forControlEvents:UIControlEventTouchUpInside];
    
    [view3 addSubview:deletebtn1];
    
    UIImageView *newimg1=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50,42, 42)];
    newimg1.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    newimg1.layer.cornerRadius = 20;
    newimg1.layer.masksToBounds = YES;
    [view3 addSubview:newimg1];
    
    label1=[[UILabel alloc]initWithFrame:CGRectMake(83, 50, 100, 50)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont systemFontOfSize:13.0]];
    label1.textColor = [UIColor blackColor];
    label1.text=@"新建群组1";
    [view3 addSubview:label1];
    
    UIImageView *newimg2=[[UIImageView alloc]initWithFrame:CGRectMake(200, 60,8, 30)];
    newimg2.image=[UIImage imageNamed:@"dialog_mach.png"];
    [view3 addSubview:newimg2];
    
    UIView *newlineview1=[[UIView alloc]initWithFrame:CGRectMake(25, 100, 200, 1)];
    newlineview1.backgroundColor=[UIColor grayColor];
    [view3 addSubview:newlineview1];
    
    
    UIImageView *img3=[[UIImageView alloc]initWithFrame:CGRectMake(30, 105,42, 42)];
    img3.image=[UIImage imageNamed:@"face_man.png"];
  
    img3.layer.cornerRadius = 20;
    img3.layer.masksToBounds = YES;
    [view3 addSubview:img3];
    
    label2=[[UILabel alloc]initWithFrame:CGRectMake(83, 105, 60, 50)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont systemFontOfSize:13.0]];
    label2.textColor = [UIColor blackColor];
    label2.text=@"新建群组2";
    [view3 addSubview:label2];
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.duration = 0.4;
    [view3.layer addAnimation:animation forKey:nil];

   
    UIImageView *newimg4=[[UIImageView alloc]initWithFrame:CGRectMake(200, 115,8, 30)];
    newimg4.image=[UIImage imageNamed:@"dialog_mach.png"];
    [view3 addSubview:newimg4];
    
    UIView *newlineview2=[[UIView alloc]initWithFrame:CGRectMake(25, 155, 200, 1)];
    newlineview2.backgroundColor=[UIColor grayColor];
    [view3 addSubview:newlineview2];
    
    MHview=[[UIView  alloc]initWithFrame:CGRectMake(10, 20, 300,500)];
    //MHview.alpha=0.4;
    MHview.backgroundColor=[UIColor  clearColor];
    [self.window addSubview:MHview];
    [MHview addSubview:view3];

    
    /*
    for (int i = 0; i < [_titleAry count]; i++) {

    MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
    float www = 1.0 / [_titleAry count];
     btn.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
    if(btn.tag == [_titleAry count] - 4){
       
        [btn setImage:[UIImage imageNamed:@"gshare_group.png"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(btn.frame.size.height/4, btn.frame.size.width/3, btn.frame.size.height /4, btn.frame.size.width /3)];
    }else{
        
    }
    
    }

*/

}
-(void)cancelbtn1:(UIButton *)sender{
  CATransition *animation = [CATransition animation];
  animation.type = kCATransitionPush;
  animation.duration = 0.4;
  [view3.layer addAnimation:animation forKey:nil];
  view3.hidden=YES;
  MHview.hidden=YES;
}

-(void)onClickUILable:(UITapGestureRecognizer *)sender{
    
    //UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    //UILabel *la=(UILabel*)tap.view;
    //---点击事件代码-------//
    view1=[[UIView alloc]initWithFrame:CGRectMake(30, 80, 240, 350)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.tag=1;
    view1.userInteractionEnabled=YES;
    NSLog(@"2222");
    [self.window addSubview:view1];
    
    
    UIButton *deletebtn=[UIButton buttonWithType:UIButtonTypeCustom];
  
    deletebtn.frame=CGRectMake(0, 0, 14, 14);
    deletebtn.tag=101;
    [deletebtn setBackgroundImage:[UIImage imageNamed:@"input_clear.png"] forState:UIControlStateNormal];
    [deletebtn addTarget:self action:@selector(cancelbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [view1 addSubview:deletebtn];
    
    //----1111111111----//
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(30, 50,42, 42)];
    img1.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    img1.layer.cornerRadius = 20;
    img1.layer.masksToBounds = YES;
    [view1 addSubview:img1];
    
    label1=[[UILabel alloc]initWithFrame:CGRectMake(83, 50, 50, 50)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont systemFontOfSize:13.0]];
    label1.textColor = [UIColor blackColor];
   // [label1 setText:@"亦庄站"];
    label1.text=@"亦庄站";
    [view1 addSubview:label1];
    
    //创建手势实例，并连接方法UITapGestureRecognizer,点击手势
   
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable1:)];
    
    label1.userInteractionEnabled=YES;
    tapGesture1.numberOfTouchesRequired=1;
    [label1 addGestureRecognizer:tapGesture1];

    UIImageView *img2=[[UIImageView alloc]initWithFrame:CGRectMake(200, 60,8, 30)];
    img2.image=[UIImage imageNamed:@"dialog_mach.png"];
    [view1 addSubview:img2];
    
    UIView *lineview1=[[UIView alloc]initWithFrame:CGRectMake(25, 100, 200, 1)];
    lineview1.backgroundColor=[UIColor grayColor];
    [view1 addSubview:lineview1];
    //----22222222222----//
    UIImageView *img3=[[UIImageView alloc]initWithFrame:CGRectMake(30, 105,42, 42)];
    img3.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    img3.layer.cornerRadius = 20;
    img3.layer.masksToBounds = YES;
    [view1 addSubview:img3];
   
    label2=[[UILabel alloc]initWithFrame:CGRectMake(83, 105, 60, 50)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont systemFontOfSize:12.0]];
    label2.textColor = [UIColor blackColor];
    label2.text=@"中关村站";
    //[label2 setText:@"中关村站"];
    [view1 addSubview:label2];
    //创建手势实例，并连接方法UITapGestureRecognizer,点击手势
    
    UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable2:)];
    
    label2.userInteractionEnabled=YES;
    tapGesture1.numberOfTouchesRequired=1;
    [label2 addGestureRecognizer:tapGesture2];

    
    UIImageView *img4=[[UIImageView alloc]initWithFrame:CGRectMake(200, 115,8, 30)];
    img4.image=[UIImage imageNamed:@"dialog_mach.png"];
    [view1 addSubview:img4];
    
    UIView *lineview2=[[UIView alloc]initWithFrame:CGRectMake(25, 155, 200, 1)];
    lineview2.backgroundColor=[UIColor grayColor];
    [view1 addSubview:lineview2];
    //-------3333333333--------//
    UIImageView *img5=[[UIImageView alloc]initWithFrame:CGRectMake(30, 160,42, 42)];
    img5.image=[UIImage imageNamed:@"face_man.png"];
    //把图片设置成圆形
    img5.layer.cornerRadius = 20;
    img5.layer.masksToBounds = YES;
    [view1 addSubview:img5];
    
    label3=[[UILabel alloc]initWithFrame:CGRectMake(83, 160, 60, 50)];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setFont:[UIFont systemFontOfSize:12.0]];
    label3.textColor = [UIColor blackColor];
    label3.text=@"天通苑站";
    //[label3 setText:@"天通苑站"];
    [view1 addSubview:label3];
    
    //创建手势实例，并连接方法UITapGestureRecognizer,点击手势
    
    UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable3:)];
    
    label3.userInteractionEnabled=YES;
    tapGesture3.numberOfTouchesRequired=1;
    [label3 addGestureRecognizer:tapGesture3];
    
    UIImageView *img6=[[UIImageView alloc]initWithFrame:CGRectMake(200, 170,8, 30)];
    img6.image=[UIImage imageNamed:@"dialog_mach.png"];
    [view1 addSubview:img6];
    
    UIView *lineview3=[[UIView alloc]initWithFrame:CGRectMake(25, 210, 200, 1)];
    lineview3.backgroundColor=[UIColor grayColor];
    [view1 addSubview:lineview3];
    //VIEW2
    view2=[[UIView alloc]initWithFrame:CGRectMake(20, 315, 200, 25)];
    view2.backgroundColor=[UIColor cyanColor];
    [view1 addSubview:view2];
   
    
    UIImageView *img7=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5,15, 15)];
    img7.image=[UIImage imageNamed:@"dialog_search.png"];
    [view2 addSubview:img7];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(50, 8, 80, 10)];
    [label4 setFont:[UIFont systemFontOfSize:13.0]];
    label4.textColor = [UIColor whiteColor];
    [label4 setText:@"更多站……"];
    [view2 addSubview:label4];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable4:)];
    
    label4.userInteractionEnabled=YES;
    tapGesture.numberOfTouchesRequired=1;
    [label4 addGestureRecognizer:tapGesture];
    
    
    MHview=[[UIView  alloc]initWithFrame:CGRectMake(10, 20, 300,500)];
    //MHview.alpha=0.4;
    MHview.backgroundColor=[UIColor  clearColor];
    [self.window addSubview:MHview];
    [MHview addSubview:view1];
    //VIEW3
    /*UIView  *view3=[[UIView alloc]initWithFrame:CGRectMake(10, 70, 250, 360)];
    view3.backgroundColor=[UIColor clearColor];
    [view1 addSubview:view3];
*/
}
-(void)onClickUILable1:(UITapGestureRecognizer *)sender{
        label.text=@"";
        label.text=label1.text;
        view1.hidden=YES;
        MHview.hidden=YES;
   
    
}
-(void)onClickUILable2:(UITapGestureRecognizer *)sender{
        label.text=@"";
        label.text=label2.text;
        view1.hidden=YES;
        MHview.hidden=YES;
  
}
-(void)onClickUILable3:(UITapGestureRecognizer *)sender{
         label.text=@"";
        label.text=label3.text;
        view1.hidden=YES;
        MHview.hidden=YES;
   
}

-(void)onClickUILable4:(UITapGestureRecognizer *)sender{

    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(40, 280,200 , 16)];
    label5.text=@"更多社区站尚未开放，敬请期待!";
    [label5 setFont:[UIFont systemFontOfSize:13.0]];
    label5.textColor = [UIColor redColor];
    [view1 addSubview:label5];
   

}
-(void)cancelbtn:(UIButton *)sender{
    
    NSLog(@"0000");
    
     //动画效果
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.duration = 0.4;
   [view1.layer addAnimation:animation forKey:nil];
    view1.hidden=YES;
    
    if(view1.hidden==YES){
        MHview.hidden=YES;
    }else{
        MHview.hidden=NO;
    }
    

    
}
- (void)loadSubView
{
    //_subView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:baseH w:1.0 h:subH onSuperBounds:self.bounds]];
    _subView = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:TopH + SubH w:1.0 h:SubH onSuperBounds:self.bounds]];
    _subView.backgroundColor = [UIColor grayColor];
    [self addSubview:_subView];
    
    //square
    _subView1 = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:1.0 onSuperBounds:_subView.bounds]];
    //_subView1.backgroundColor = [UIColor grayColor];
    [_subView addSubview:_subView1];
    _subView1.tag = E_square;
    
    
    //local title
    _loaclLb = [[UILabel alloc] init];
    _loaclLb.frame = [Common RectMakex:0 y:0 w:0.25 h:1.0 onSuperBounds:_subView1.bounds];
    //_loaclLb.text = @"我的位置";
    _loaclLb.textColor = [UIColor blackColor];
    _loaclLb.textAlignment = NSTextAlignmentCenter;
    [_subView1 addSubview:_loaclLb];
    //
    _scrollv = [[UIScrollView alloc] init];
    _scrollv.frame = [Common RectMakex:0.25 y:0 w:0.75 h:1.0 onSuperBounds:_subView1.bounds];
    _scrollv.contentSize = CGSizeMake(_subView1.bounds.size.width * 1.1, _subView1.bounds.size.height);
    _scrollv.showsHorizontalScrollIndicator = NO;
    [_subView1 addSubview:_scrollv];
    /*
    NSArray *subView1titleAry = @[@"精华", @"全部", @"活动", @"吐槽01"];
    float w1 = _scrollv.contentSize.width / [subView1titleAry count];
    for (int i = 0; i < [subView1titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(w1 * i, 0, w1, _scrollv.contentSize.height);
        [btn setTitle:[subView1titleAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelectedImageModel:E_Changtiao];
        [btn addTarget:self action:@selector(sub1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_scrollv addSubview:btn];
    }
    */
    //group
    _subView2 = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:1.0 onSuperBounds:_subView.bounds]];
    //_subView2.backgroundColor = [UIColor grayColor];
    [_subView addSubview:_subView2];
    _subView2.tag = E_group;
  /*
    NSArray *subView2titleAry = @[@"我的", @"附近"];
    float w2 = 1.0 / [subView2titleAry count];
    for (int i = 0; i < [subView2titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [Common RectMakex:w2 * i y:0 w:w2 h:1.0 onSuperBounds:_subView2.bounds];
        [btn setTitle:[subView2titleAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelectedImageModel:E_Changtiao];
        [btn addTarget:self action:@selector(sub2BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_subView2 addSubview:btn];
    }
    */
    //own
    _subView3 = [[UIView alloc] initWithFrame:[Common RectMakex:0 y:0.0 w:1.0 h:1.0 onSuperBounds:_subView.bounds]];
    //_subView3.backgroundColor = [UIColor grayColor];
    [_subView addSubview:_subView3];
    _subView3.tag = E_own;

    NSArray *subView3titleAry = @[@"好友", @"消息", @"我"];
    float w3 = 1.0 / [subView3titleAry count];
    for (int i = 0; i < [subView3titleAry count]; i++) {
        MyButton *btn = [MyButton buttonWithType:UIButtonTypeCustom];
        btn.frame = [Common RectMakex:w3 * i y:0 w:w3 h:1.0 onSuperBounds:_subView3.bounds];
        [btn setTitle:[subView3titleAry objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelectedImageModel:E_Changtiao];
        [btn addTarget:self action:@selector(sub3BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i];
        [_subView3 addSubview:btn];
    }
 
    
}

- (void)setLocalTitle:(NSString *)loacl
{
    _loaclLb.text = loacl;
}

- (void)setDefaultShow
{
    _squareIndex = E_ShowView_Square_QuanBu;
    _groupIndex = E_ShowView_Group_WoDe;
    _ownIndex = E_ShowView_Own_MiYou;
    [self setDefaultSub1Show:_squareIndex];
    [self setDefaultSub2Show:_groupIndex];
    [self setDefaultSub3Show:_ownIndex];
    
    [self setDefaultBaseShow:E_square];
}

- (void)setDefaultBaseShow:(int)DefautBaseTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _baseView.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == DefautBaseTag) {
                defautBtn = btn;
            }
        }
    }
    if (defautBtn) {
        [self baseBtnAction:defautBtn];
    }
    else
    {
        NSLog(@"defautBtn nil");
    }
}

- (void)setDefaultSub1Show:(int)curSelectTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _scrollv.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == curSelectTag) {
                defautBtn = btn;
            }
        }
    }
    [self sub1BtnAction:defautBtn];
}

- (void)setDefaultSub2Show:(int)curSelectTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _subView2.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == curSelectTag) {
                defautBtn = btn;
            }
        }
    }
    [self sub2BtnAction:defautBtn];
}

- (void)setDefaultSub3Show:(int)curSelectTag
{
    MyButton *defautBtn = nil;
    for (MyButton *btn in _subView3.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn.tag == curSelectTag) {
                defautBtn = btn;
            }
        }
    }
    [self sub3BtnAction:defautBtn];
}

- (void)setSubViewShow:(int)tag
{
    switch (tag) {
        case E_square:
        {
            _subView1.hidden = NO;
            _subView2.hidden = YES;
            _subView3.hidden = YES;
            [self setDefaultSub1Show:_squareIndex];
        }
            break;
        case E_group:
        {
            _subView1.hidden = YES;
            _subView2.hidden = NO;
            _subView3.hidden = YES;
            [self setDefaultSub2Show:_groupIndex];
        }
            break;
        case E_own:
        {
            _subView1.hidden = YES;
            _subView2.hidden = YES;
            _subView3.hidden = NO;
            [self setDefaultSub3Show:_ownIndex];
        }
            break;
        default:
            break;
    }
}

#pragma mark btn action

- (void)baseBtnAction:(MyButton *)sender
{
    NSLog(@"btn sender.tag==%d", sender.tag);
    if (sender.tag == [_titleAry count] - 4) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showChatView)]) {
            [self.delegate showChatView];
        }
    }
    else
    {
        for (MyButton *btn in _baseView.subviews) {
            if ([btn isKindOfClass:[MyButton class]]) {
                if (btn.tag == sender.tag) {
                    sender.selected = YES;
                }
                else
                {
                    btn.selected = NO;
                }
            }
        }
        [self setSubViewShow:sender.tag];
    }
}

- (void)sub1BtnAction:(MyButton *)sender
{
    for (MyButton *btn in _scrollv.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn == sender) {
                sender.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    _squareIndex = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSquareSelectViewByTag:)]) {
        [self.delegate showSquareSelectViewByTag:sender.tag];
    }
}

- (void)sub2BtnAction:(MyButton *)sender
{
    for (MyButton *btn in _subView2.subviews) {
        if ([btn isKindOfClass:[MyButton class]]) {
            if (btn == sender) {
                sender.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
    _groupIndex = sender.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(showGroupSelectViewByTag:)]) {
        [self.delegate showGroupSelectViewByTag:sender.tag];
    }
}

- (void)sub3BtnAction:(MyButton *)sender
{
    if (sender.tag == E_ShowView_Own_MingPian) {

    }
    else
    {
        for (MyButton *btn in _subView3.subviews) {
            if ([btn isKindOfClass:[MyButton class]]) {
                if (btn == sender) {
                    sender.selected = YES;
                }
                else
                {
                    btn.selected = NO;
                }
            }
        }
        _ownIndex = sender.tag;
    }
  
    if (self.delegate && [self.delegate respondsToSelector:@selector(showOwnSelectViewByTag:)]) {
        [self.delegate showOwnSelectViewByTag:sender.tag];
    }
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
