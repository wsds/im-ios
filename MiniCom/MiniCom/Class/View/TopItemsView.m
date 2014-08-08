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
    
    
    _titleAry = @[@"广播", @"广场", @"群组", @""];
    
    float www = 1.0 / [_titleAry count];

    for (int i = 0; i < [_titleAry count]; i++) {
        MyButton *btn1 = [MyButton buttonWithType:UIButtonTypeCustom];
        MyButton *btn2 = [MyButton buttonWithType:UIButtonTypeCustom];
        MyButton *btn3 = [MyButton buttonWithType:UIButtonTypeCustom];
        MyButton *btn4 = [MyButton buttonWithType:UIButtonTypeCustom];
        
        btn1.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        
        btn2.frame = [Common RectMakex:(www * i)*1.5  y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        
        btn3.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        btn4.frame = [Common RectMakex:www * i y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
       
    
        if (i == [_titleAry count] - 4) {
            [btn1 setImage:[UIImage imageNamed:@"square_release.png"] forState:UIControlStateNormal];
            [btn1 setImageEdgeInsets:UIEdgeInsetsMake(btn1.frame.size.height/4, btn1.frame.size.width/3, btn1.frame.size.height /4, btn1.frame.size.width /3)];
        }
         
        else if(i == [_titleAry count]-3){
            [btn2 setImage:[UIImage imageNamed:@"square_icon_selected.png"] forState:UIControlStateNormal];
            [btn2 setImageEdgeInsets:UIEdgeInsetsMake(btn2.frame.size.height/4, btn2.frame.size.width/1, btn2.frame.size.height /4, btn2.frame.size.width /3)];
        
        
        }else if(i == [_titleAry count]- 2){
            [btn3 setImage:[UIImage imageNamed:@"group_icon.png"] forState:UIControlStateNormal];
            [btn3 setImageEdgeInsets:UIEdgeInsetsMake(btn3.frame.size.height/4, btn3.frame.size.width/1, btn3.frame.size.height /4, btn3.frame.size.width /3)];
        
        }else if(i == [_titleAry count] -1){
        {
           [btn4 setImage:[UIImage imageNamed:@"person_icon.png"] forState:UIControlStateNormal];
           [btn4 setImageEdgeInsets:UIEdgeInsetsMake(btn4.frame.size.height/4, btn4.frame.size.width/3, btn4.frame.size.height /4, btn4.frame.size.width /3)];
            
            
            [btn1 setTitle:[_titleAry objectAtIndex:i] forState:UIControlStateNormal];
            [btn1 setSelectedImageModel:E_Sanjiao];
            
            
        }
        }
        [btn1 addTarget:self action:@selector(baseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTag:i];
        
        [btn2 addTarget:self action:@selector(sub1BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setTag:i];
        
        [btn3 addTarget:self action:@selector(sub2BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 setTag:i];
        
        [btn4 addTarget:self action:@selector(sub3BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn4 setTag:i];
        
        
        UILabel  *label=[[UILabel alloc]init];
        label.frame=[Common RectMakex:www  y:0 w:www h:1.0 onSuperBounds:_baseView.bounds];
        label.text=@"亦庄站";
        label.textColor = [UIColor whiteColor];
        //创建手势实例，并连接方法UITapGestureRecognizer,点击手势
        
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUILable:)];
        
        label.userInteractionEnabled=YES;
        tapGesture.numberOfTouchesRequired=1;
        [label addGestureRecognizer:tapGesture];
        [_baseView addSubview:label];
        
        
        [_baseView addSubview:btn1];
        [_baseView addSubview:btn2];
        [_baseView addSubview:btn3];
        [_baseView addSubview:btn4];
         
    }
}

-(void)onClickUILable:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    
    //UILabel *la=(UILabel*)tap.view;
    //---点击事件代码-------//
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(40, 80, 240, 350)];
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
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(83, 50, 50, 50)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    [label1 setFont:[UIFont systemFontOfSize:13.0]];
    label1.textColor = [UIColor blackColor];
    [label1 setText:@"亦庄站"];
    [view1 addSubview:label1];
    
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
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(83, 105, 60, 50)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    [label2 setFont:[UIFont systemFontOfSize:13.0]];
    label2.textColor = [UIColor blackColor];
    [label2 setText:@"中关村站"];
    [view1 addSubview:label2];
    
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
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(83, 160, 60, 50)];
    [label3 setBackgroundColor:[UIColor clearColor]];
    [label3 setFont:[UIFont systemFontOfSize:13.0]];
    label3.textColor = [UIColor blackColor];
    [label3 setText:@"天通苑站"];
    [view1 addSubview:label3];
    
    UIImageView *img6=[[UIImageView alloc]initWithFrame:CGRectMake(200, 170,8, 30)];
    img6.image=[UIImage imageNamed:@"dialog_mach.png"];
    [view1 addSubview:img6];
    
    UIView *lineview3=[[UIView alloc]initWithFrame:CGRectMake(25, 210, 200, 1)];
    lineview3.backgroundColor=[UIColor grayColor];
    [view1 addSubview:lineview3];
    
    UIView  *view2=[[UIView alloc]initWithFrame:CGRectMake(20, 315, 200, 25)];
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

}
-(void)onClickUILable4:(UITapGestureRecognizer *)sender{

    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(90, 100,200 , 16)];
    label5.text=@"更多社区站尚未开放，敬请期待!";
    [label5 setFont:[UIFont systemFontOfSize:13.0]];
    label5.textColor = [UIColor redColor];
    [self.window addSubview:label5];
   

}
-(void)cancelbtn:(UIButton *)sender{
    
    NSLog(@"0000");
   
    
  
 
    
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
/*
    NSArray *subView3titleAry = @[@"密友", @"消息", @"名片"];
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
 */
    
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
