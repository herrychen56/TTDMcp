//
//  UIKeyboard.h
//  Baseframework
//
//  Created by Zanilia on 16/8/14.
//

#import <UIKit/UIKit.h>
#import "UIFaceKeyboardView.h"
#import "UIMoreKeyboardView.h"
@protocol UIKeyboardBarDelegate;

typedef NS_ENUM(NSUInteger, UIKeyboardChatType) {
    UIKeyboardChatTypeDefault       = 1,          //默认的原始状态
    UIKeyboardChatTypeKeyboard      = 2,          //Keyboard system keyboard or athird party键盘系统键盘或第三方
    UIKeyboardChatTypeFace          = 3,          //Expression on the keyboard 键盘上的表情
    UIKeyboardChatTypeVoice         = 4,          //Phonetic keyboard 语音键盘
    UIKeyboardChatTypeMore          = 5           //More keyboard operation 更多的键盘操作
};

/**
 *  Universal keyboard (mainly, expression, other (pictures, location, etc.), voice)...
 */
@interface UIKeyboardBar : UITabBar
@property (assign, nonatomic) UIKeyboardChatType type;
@property (nonatomic) BOOL showFaceKeyboard;    //表情键盘，Default NO
@property (strong, nonatomic) UIFaceKeyboardView *faceView;
@property (strong, nonatomic) UIMoreKeyboardView *moreView;


// State of the input,default NO
@property (nonatomic) BOOL inputing;

// State of the input,default NO
@property (nonatomic) BOOL textViewFirstResponder;

//Start the input box is the first responder,default NO
@property (nonatomic, strong) NSString *placehoder;

// have the expression, this property must be assigned
@property (nonatomic, strong) NSString *expressionBundleName;
/// /键盘需要你选择,键盘是默认的,@(@(UIKeyboardChatTypeKeyboard)…)
//What keyboard to need your choice, the keyboard is the default ,@[@(UIKeyboardChatTypeKeyboard),...]
@property (nonatomic, strong) NSArray *keyboardTypes;
//其他在标题下的操作，如图像、视频@[@ "title1"，@"title2 "，…]
//Other operating under the title, such as image, video @[@"title1",@"title2",...]
@property (nonatomic, strong) NSArray *KeyboardMoreTitles;
/// /其他操作图标，如图片，视频@[@ "imageName1"，@"imageName2 "，…]
//Other operating under the icon, such as pictures, video @[@"imageName1",@"imageName2",...]
@property (nonatomic, strong) NSArray *KeyboardMoreImages;

//Send button color, the default is blue
@property (nonatomic, strong) UIColor *faceSendColor;

/*
 *Special note
 *expressionBundleName，KeyboardMoreTitles and KeyboardMoreImages assignment Or count assignment 0 Or @""，All hide
 */


@property (nonatomic, strong) id<UIKeyboardBarDelegate> barDelegate;    //default nil


//The input end of state, Property inputing state to NO
- (void)endInput;
@end


@protocol UIKeyboardBarDelegate <NSObject>

@optional

//To switch the keyboard height change constantly
- (void)keyboardBar:(UIKeyboardBar *)keyboard didChangeFrame:(CGRect)frame;

//Choose other more operating under the keyboard keyboard =(UIKeyboardChatTypeMore)
- (void)keyboardBar:(UIKeyboardBar *)keyboard moreHandleAtItemIndex:(NSInteger)index;

//Send text or expression.....UIKeyboardChatTypeFace
- (void)keyboardBar:(UIKeyboardBar *)keyboard sendContent:(NSString *)message;

//Send voice, return parameter for speech bytes and speech....UIKeyboardChatTypeMore
- (void)keyboardBar:(UIKeyboardBar *)keyboard sendVoiceWithFilePath:(NSString *)path seconds:(NSTimeInterval)seconds;



@end

