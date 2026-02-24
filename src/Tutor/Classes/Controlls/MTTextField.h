//
//  MTTextField.h
//  Tutor
//
//  Created by Dominic Rodemer on 13.08.23.
//

#import <UIKit/UIKit.h>

@protocol MTTextFieldDelegate;

@interface MTTextField : UITextField <UITextFieldDelegate, UIScribbleInteractionDelegate>
{
    __weak id<MTTextFieldDelegate> textFieldDelegate;
    
    NSDictionary *textAttributes;
    UILabel *label;
}

@property (nonatomic, weak) id<MTTextFieldDelegate> textFieldDelegate;

@property (nonatomic, strong) NSDictionary *textAttributes;

- (CGSize)size;

@end

@protocol MTTextFieldDelegate <NSObject>

- (void)textFieldNeedsLayout:(MTTextField *)textField;

@end
