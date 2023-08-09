//
//  MTTutorViewController.h
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import <UIKit/UIKit.h>

#import <PencilKit/PencilKit.h>

#import "MTButton.h"

@interface MTTutorViewController : UIViewController
{
    MTButton *clearCanvasButton;
    MTButton *undoButton;
    MTButton *redoButton;
    
    MTButton *toggleHeadlineButton;
    MTButton *toggleTextButton;
    
    MTButton *whitePenButton;
    MTButton *redPenButton;
    MTButton *greenPenButton;
    MTButton *bluePenButton;
    
    MTButton *eraserButton;
    
    UIView *canvasContainerView;
    UIView *canvasGridView;
    PKCanvasView *canvasView;
    
    PKInkingTool *whiteInkTool;
    PKInkingTool *redInkTool;
    PKInkingTool *greenInkTool;
    PKInkingTool *blueInkTool;
    PKEraserTool *eraserTool;
        
    UITextField *headlineTextField;
    UITextField *textField;
}


@end

