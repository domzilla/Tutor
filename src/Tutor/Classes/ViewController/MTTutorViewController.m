//
//  MTTutorViewController.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import "MTTutorViewController.h"

@interface MTTutorViewController ()

- (void)activateTool:(PKTool *)tool;

@end

@implementation MTTutorViewController

#define TTCanvasWidth 1112
#define TTCanvasHeight 834

#define TTPenWidth 4.0

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        whiteInkTool = [[PKInkingTool alloc] initWithInkType:PKInkTypePen color:[UIColor whiteColor] width:TTPenWidth];
        redInkTool = [[PKInkingTool alloc] initWithInkType:PKInkTypePen color:[UIColor redColor] width:TTPenWidth];
        greenInkTool = [[PKInkingTool alloc] initWithInkType:PKInkTypePen color:[UIColor greenColor] width:TTPenWidth];
        blueInkTool = [[PKInkingTool alloc] initWithInkType:PKInkTypePen color:[UIColor blueColor] width:TTPenWidth];
        eraserTool = [[PKEraserTool alloc] initWithEraserType:PKEraserTypeBitmap];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
        
    canvasBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    canvasBackgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:canvasBackgroundView];
    
    canvasView = [[PKCanvasView alloc] initWithFrame:CGRectZero];
    canvasView.backgroundColor = [UIColor clearColor];
    canvasView.opaque = YES;
    canvasView.drawingPolicy = PKCanvasViewDrawingPolicyPencilOnly;
    canvasView.drawing = [[PKDrawing alloc] init];
    [self.view addSubview:canvasView];
    
    UIImageSymbolConfiguration *symbolConfiguration = [UIImageSymbolConfiguration configurationWithPointSize:20 weight:UIImageSymbolWeightRegular scale:UIImageSymbolScaleMedium];
    
    clearCanvasButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"trash.fill"
                                                          withConfiguration:symbolConfiguration]];
    [clearCanvasButton addTarget:self
                          action:@selector(clearCanvasButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearCanvasButton];
    
    undoButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"arrow.uturn.backward"
                                                   withConfiguration:symbolConfiguration]];
    [undoButton addTarget:self
                          action:@selector(undoButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:undoButton];
    
    redoButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"arrow.uturn.forward"
                                                   withConfiguration:symbolConfiguration]];
    [redoButton addTarget:self
                          action:@selector(redoButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redoButton];
    
    toggleHeadlineButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"underline"
                                                             withConfiguration:symbolConfiguration]];
    [toggleHeadlineButton addTarget:self
                          action:@selector(toggleHeadlineButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleHeadlineButton];
    
    toggleTextButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"character.textbox"
                                                         withConfiguration:symbolConfiguration]];
    [toggleTextButton addTarget:self
                          action:@selector(toggleTextButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleTextButton];
    
    whitePenButton = [MTButton buttonWithColor:[UIColor whiteColor]];
    [whitePenButton addTarget:self
                          action:@selector(whitePenButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whitePenButton];
        
    redPenButton = [MTButton buttonWithColor:[UIColor redColor]];
    [redPenButton addTarget:self
                          action:@selector(redPenButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redPenButton];
    
    greenPenButton = [MTButton buttonWithColor:[UIColor greenColor]];
    [greenPenButton addTarget:self
                          action:@selector(greenPenButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:greenPenButton];
    
    bluePenButton = [MTButton buttonWithColor:[UIColor blueColor]];
    [bluePenButton addTarget:self
                          action:@selector(bluePenButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bluePenButton];
    
    eraserButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"eraser.fill"
                                                     withConfiguration:symbolConfiguration]];
    [eraserButton addTarget:self
                          action:@selector(eraserButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraserButton];
    
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
        
    CGFloat toolbarWidth = self.view.frame.size.width - TTCanvasWidth;
    canvasBackgroundView.frame = CGRectMake(toolbarWidth,
                                            0.0,
                                            TTCanvasWidth,
                                            TTCanvasHeight);
    canvasView.frame = canvasBackgroundView.frame;
    
    CGFloat offset = 20.0;
    CGSize buttonSize = [MTButton buttonSize];
    CGPoint buttonOrigin = CGPointMake(toolbarWidth/2 - buttonSize.width/2,
                                       buttonSize.height);
    
    clearCanvasButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
    undoButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
    redoButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + 2*offset;
    
    toggleHeadlineButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
    toggleTextButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + 2*offset;
    
    whitePenButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
    redPenButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
    greenPenButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
    bluePenButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + 2*offset;
    
    eraserButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.y += buttonSize.height + offset;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}


#pragma mark Actions
#pragma mark ---
- (void)clearCanvasButtonAction:(id)sender
{
    canvasView.drawing = [[PKDrawing alloc] init];
}

- (void)undoButtonAction:(id)sender
{
    [canvasView.undoManager undo];
}

- (void)redoButtonAction:(id)sender
{
    [canvasView.undoManager redo];
}

- (void)toggleHeadlineButtonAction:(id)sender
{
    
}

- (void)toggleTextButtonAction:(id)sender
{
    
}

- (void)whitePenButtonAction:(id)sender
{
    [self activateTool:whiteInkTool];
}

- (void)redPenButtonAction:(id)sender
{
    [self activateTool:redInkTool];
}

- (void)greenPenButtonAction:(id)sender
{
    [self activateTool:greenInkTool];
}

- (void)bluePenButtonAction:(id)sender
{
    [self activateTool:blueInkTool];
}

- (void)eraserButtonAction:(id)sender
{
    [self activateTool:eraserTool];
}


#pragma mark Private
#pragma mark ---
- (void)activateTool:(PKTool *)tool
{
    if (tool == canvasView.tool)
        return;
    
    whitePenButton.on = (tool == whiteInkTool);
    redPenButton.on = (tool == redInkTool);
    greenPenButton.on = (tool == greenInkTool);
    bluePenButton.on = (tool == blueInkTool);
    eraserButton.on = (tool == eraserTool);
    
    canvasView.tool = tool;
}

@end
