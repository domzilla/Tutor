//
//  MTTutorViewController.h
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import <UIKit/UIKit.h>

#import <PencilKit/PencilKit.h>

#import "MTInkingTool.h"
#import "MTButton.h"

typedef NS_ENUM(NSUInteger, MTTutorViewControllerInkStyle) {
    MTTutorViewControllerInkStylePen = 0,
    MTTutorViewControllerInkStyleFatPen,
    MTTutorViewControllerInkStyleMarker,
};

@interface MTTutorViewController : UIViewController <UITextFieldDelegate, UIScribbleInteractionDelegate>
{
    MTButton *clearCanvasButton;
    MTButton *undoButton;
    MTButton *redoButton;
    
    MTButton *toggleHeadlineButton;
    MTButton *toggleSubtextButton;
    
    MTButton *nextCanvasButton;
    MTButton *previousCanvasButton;
    UILabel *canvasLabel;
    
    MTButton *whiteInkButton;
    MTButton *redInkButton;
    MTButton *greenInkButton;
    MTButton *blueInkButton;
    MTButton *yellowInkButton;
    
    MTButton *eraserButton;
    
    UISegmentedControl *inkStyleControl;
    
    UIView *canvasContainerView;
    UIView *canvasGridView;
    PKCanvasView *canvasView;
    
    NSMutableArray *canvasViews;
    
    MTInkingTool *whiteInkTool;
    MTInkingTool *redInkTool;
    MTInkingTool *greenInkTool;
    MTInkingTool *blueInkTool;
    MTInkingTool *yellowInkTool;
    MTInkingTool *activeInkTool;
    
    PKEraserTool *eraserTool;
    
    UITextField *headlineTextField;
    UILabel *headlineLabel;
    BOOL showsHeadlineTextField;
    
    UITextField *subtextField;
    UILabel *subtextLabel;
    BOOL showsSubtextField;
    
    MTTutorViewControllerInkStyle inkStyle;
}

@property (nonatomic, assign) MTTutorViewControllerInkStyle inkStyle;

@end

