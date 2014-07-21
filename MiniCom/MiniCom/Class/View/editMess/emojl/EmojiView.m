
#import "EmojiView.h"
#import "menuImageView.h"
#import "FaceView.h"
#import "GifView.h"
#import "AppDelegate.h"

@implementation EmojiView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _faceView = [[FaceView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height-44)];
        [self addSubview:_faceView];
        _faceView.hidden   = NO;
        
        _gifView = [[GifView alloc]initWithFrame:CGRectMake(0, 0, 320, self.frame.size.height-44)];
        [self addSubview:_gifView];
        _gifView.hidden   = YES;

        _menu = [MenuImageView alloc];
        //_menu.items = [NSMutableArray arrayWithObjects:@"表情",@"动画",@"声音",@"其他",nil];
        _menu.items = [NSMutableArray arrayWithObjects:@"表情",@"动画",nil];
        _menu.type  = 0;
        _menu.delegate = self;
        _menu.offset   = 0;
        _menu.itemWidth = 75;
        _menu.onClick  = @selector(actionSegment:);
        [_menu initWithFrame:CGRectMake(0, self.frame.size.height-44, 320, 44)];
        //_menu.frame = CGRectMake(0, self.frame.size.height-44, 320, 44);
        [self addSubview:_menu];
        [_menu selectOne:0];
        
}
    return self;
}

-(void)actionSegment:(UIButton*)sender{
    switch (sender.tag){
        case 0:
            _faceView.hidden   = NO;
            _gifView.hidden   = YES;
            break;
        case 1:
            _faceView.hidden   = YES;
            _gifView.hidden   = NO;
            break;
    }
}

-(void)setDelegate:(UITextView *)value{
    if(delegate != value){
        delegate = value;
        _faceView.delegate = delegate;
        _gifView.delegate = delegate;
    }
}

@end