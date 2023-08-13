//
//  MTTextField.m
//  Tutor
//
//  Created by Dominic Rodemer on 13.08.23.
//

#import "MTTextField.h"

@implementation MTTextField

@synthesize textFieldDelegate;
@synthesize textAttributes;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.delegate = self;
        
        [self addInteraction:[[UIScribbleInteraction alloc] initWithDelegate:self]];
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeSystem primaryAction:[UIAction actionWithHandler:^(UIAction *action) {
            self.text = nil;
        }]];
        clearButton.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [clearButton setImage:[UIImage systemImageNamed:@"x.square.fill"] forState:UIControlStateNormal];
        clearButton.frame = CGRectMake(0.0, 0.0, 50.0, 0.0);
        self.rightView = clearButton;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        
        label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.userInteractionEnabled = NO;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:60.0];
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    self.tintColor = textColor;
    label.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    label.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    
    label.textAlignment = textAlignment;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{
    [super setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
    
    label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize
{
    [super setMinimumFontSize:minimumFontSize];
    
    label.minimumScaleFactor = minimumFontSize / self.font.pointSize;
}


#pragma mark Public
#pragma mark ---
- (CGSize)size
{
    return [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)];
}



#pragma mark UITextFieldDelegate
#pragma mark ---
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return !self.hidden;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.text = label.text;
    label.attributedText = nil;
    
    if ([textFieldDelegate respondsToSelector:@selector(textFieldNeedsLayout:)])
    {
        [textFieldDelegate textFieldNeedsLayout:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textAttributes)
    {
        label.attributedText = [[NSAttributedString alloc] initWithString:self.text
                                                                       attributes:textAttributes];
        self.text = nil;
    }
    else
    {
        label.text = self.text;
        self.text = nil;
    }
    
    if ([textFieldDelegate respondsToSelector:@selector(textFieldNeedsLayout:)])
    {
        [textFieldDelegate textFieldNeedsLayout:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



#pragma mark UIScribbleInteractionDelegate
#pragma mark ---
- (BOOL)scribbleInteraction:(UIScribbleInteraction *)interaction shouldBeginAtLocation:(CGPoint)location
{
    return NO;
}


@end
