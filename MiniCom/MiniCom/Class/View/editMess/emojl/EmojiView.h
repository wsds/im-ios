
#import <UIKit/UIKit.h>
@class MenuImageView;
@class FaceView;
@class GifView;

@interface EmojiView: UIView{
    FaceView* _faceView;
    GifView* _gifView;
    
    MenuImageView* _menu;
}

@property (nonatomic, assign) UITextView* delegate;

@end
