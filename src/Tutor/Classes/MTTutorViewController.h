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
#import "MTSegmentedControl.h"
#import "MTTextField.h"

typedef NS_ENUM(NSUInteger, MTTutorViewControllerInkStyle) {
    MTTutorViewControllerInkStylePen = 0,
    MTTutorViewControllerInkStyleFatPen,
    MTTutorViewControllerInkStyleMarker,
};

@interface MTTutorViewController : UIViewController <MTTextFieldDelegate>
{
    MTButton *clearCanvasButton;
    MTButton *undoButton;
    MTButton *redoButton;
    
    MTButton *toggleHeadlineButton;
    MTButton *toggleSubtextButton;
    
    MTButton *nextCanvasButton;
    MTButton *previousCanvasButton;
    UILabel *canvasLabel;
    
    MTButton *primaryInkButton;
    MTButton *redInkButton;
    MTButton *greenInkButton;
    MTButton *blueInkButton;
    MTButton *yellowInkButton;
    
    MTButton *eraserButton;
    
    MTSegmentedControl *inkStyleControl;
    
    UIView *canvasContainerView;
    UIView *canvasGridView;
    PKCanvasView *canvasView;
    
    NSMutableArray *canvasViews;
    
    MTInkingTool *primaryInkTool;
    MTInkingTool *redInkTool;
    MTInkingTool *greenInkTool;
    MTInkingTool *blueInkTool;
    MTInkingTool *yellowInkTool;
    MTInkingTool *activeInkTool;
    
    PKEraserTool *eraserTool;
    
    MTTextField *headlineTextField;
    BOOL showsHeadlineTextField;
    
    MTTextField *subtextField;
    BOOL showsSubtextField;
    
    MTTutorViewControllerInkStyle inkStyle;
}

@property (nonatomic, assign) MTTutorViewControllerInkStyle inkStyle;

@end

