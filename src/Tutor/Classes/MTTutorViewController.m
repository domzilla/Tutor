//
//  MTTutorViewController.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import "MTTutorViewController.h"

#import "UIColor+Tutor.h"

@interface MTTutorViewController ()

- (void)activateTool:(PKTool *)tool;

@end

@implementation MTTutorViewController

#define TTCanvasGridSize 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        eraserTool = [[PKEraserTool alloc] initWithEraserType:PKEraserTypeBitmap];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    canvasContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    canvasContainerView.backgroundColor = [UIColor blackColor];
    canvasContainerView.layer.masksToBounds = YES;
    [self.view addSubview:canvasContainerView];
        
    canvasGridView = [[UIView alloc] initWithFrame:CGRectZero];
    canvasGridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"canvas_grid"]];
    [canvasContainerView addSubview:canvasGridView];
    
    canvasView = [[PKCanvasView alloc] initWithFrame:CGRectZero];
    canvasView.backgroundColor = [UIColor clearColor];
    canvasView.opaque = YES;
    canvasView.drawingPolicy = PKCanvasViewDrawingPolicyPencilOnly;
    canvasView.drawing = [[PKDrawing alloc] init];
    [canvasContainerView addSubview:canvasView];
    
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
    
    whiteInkButton = [MTButton buttonWithColor:[UIColor whiteColor]];
    [whiteInkButton addTarget:self
                          action:@selector(whiteInkButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whiteInkButton];
        
    redInkButton = [MTButton buttonWithColor:[UIColor mt_redColor]];
    [redInkButton addTarget:self
                          action:@selector(redInkButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redInkButton];
    
    greenInkButton = [MTButton buttonWithColor:[UIColor mt_greenColor]];
    [greenInkButton addTarget:self
                          action:@selector(greenInkButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:greenInkButton];
    
    blueInkButton = [MTButton buttonWithColor:[UIColor mt_blueColor]];
    [blueInkButton addTarget:self
                          action:@selector(blueInkButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueInkButton];
    
    yellowInkButton = [MTButton buttonWithColor:[UIColor mt_yellowColor]];
    [yellowInkButton addTarget:self
                        action:@selector(yellowInkButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yellowInkButton];
    
    eraserButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"eraser.fill"
                                                     withConfiguration:symbolConfiguration]];
    [eraserButton addTarget:self
                          action:@selector(eraserButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraserButton];
    
    inkStyleControl = [[UISegmentedControl alloc] initWithItems:@[[UIImage systemImageNamed:@"scribble"
                                                                          withConfiguration:symbolConfiguration],
                                                                  [UIImage systemImageNamed:@"scribble.variable"
                                                                          withConfiguration:symbolConfiguration],
                                                                  [UIImage systemImageNamed:@"highlighter"
                                                                          withConfiguration:symbolConfiguration]]];
    [inkStyleControl addTarget:self action:@selector(inkStyleControlAction:) forControlEvents:UIControlEventValueChanged];
    inkStyleControl.layer.borderWidth = 2.0;
    inkStyleControl.layer.borderColor = [[UIColor mt_tintColor] CGColor];
    [self.view addSubview:inkStyleControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inkStyle = MTTutorViewControllerInkStylePen;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat canvasWidth = self.view.frame.size.width;
    CGFloat canvasHeight = floorf(canvasWidth/16 * 9);
    CGRect topToolbarFrame = CGRectMake(0.0,
                                        self.view.safeAreaInsets.top,
                                        self.view.frame.size.width,
                                        floorf((self.view.frame.size.height - canvasHeight) / 2) - self.view.safeAreaInsets.top);
    CGRect bottomToolbarFrame = CGRectMake(0.0,
                                           topToolbarFrame.origin.y + topToolbarFrame.size.height + canvasHeight,
                                           self.view.frame.size.width,
                                           self.view.frame.size.height - topToolbarFrame.origin.y -  topToolbarFrame.size.height - canvasHeight - self.view.safeAreaInsets.bottom);
    CGSize gridSize = CGSizeMake(floorf(canvasWidth/TTCanvasGridSize)*TTCanvasGridSize + TTCanvasGridSize,
                                 floorf(canvasHeight/TTCanvasGridSize)*TTCanvasGridSize + TTCanvasGridSize);
    
    canvasContainerView.frame = CGRectMake(0.0,
                                           topToolbarFrame.origin.y + topToolbarFrame.size.height,
                                           canvasWidth,
                                           canvasHeight);
    canvasGridView.frame = CGRectMake(floorf((canvasContainerView.frame.size.width - gridSize.width) / 2),
                                      floorf((canvasContainerView.frame.size.height - gridSize.height) / 2),
                                      gridSize.width,
                                      gridSize.height);
    canvasView.frame = canvasContainerView.bounds;
    
    CGFloat offset = 20.0;
    CGSize buttonSize = [MTButton buttonSize];
    CGPoint buttonOrigin = CGPointMake(offset, topToolbarFrame.origin.y + floorf(topToolbarFrame.size.height/2 - buttonSize.height/2));
    
    clearCanvasButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    undoButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    redoButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + 2*offset;
    
    toggleHeadlineButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    toggleTextButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + 2*offset;
    
    buttonOrigin = CGPointMake(offset, bottomToolbarFrame.origin.y + floorf(bottomToolbarFrame.size.height/2 - buttonSize.height/2));
    
    whiteInkButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    redInkButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    greenInkButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    blueInkButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + offset;
    yellowInkButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x += buttonSize.width + 2*offset;
    
    inkStyleControl.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, inkStyleControl.frame.size.width, buttonSize.height);
    buttonOrigin.x += inkStyleControl.frame.size.width + 2*offset;
    
    eraserButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
}


#pragma mark Accessors
#pragma mark ---
- (MTTutorViewControllerInkStyle)inkStyle
{
    return inkStyle;
}

- (void)setInkStyle:(MTTutorViewControllerInkStyle)anInkStyle
{
    inkStyle = anInkStyle;
    
    PKInkType inkType = PKInkTypePen;
    CGFloat inkWidth = 4.0;
    
    if (inkStyle == MTTutorViewControllerInkStyleFatPen)
    {
        inkWidth = 15.0;
    }
    else if (inkStyle == MTTutorViewControllerInkStyleMarker)
    {
        inkType = PKInkTypeMarker;
        inkWidth = 20.0;
    }
    
    whiteInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor whiteColor] width:inkWidth identifier:0];
    redInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_redColor] width:inkWidth identifier:1];
    greenInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_greenColor] width:inkWidth identifier:2];
    blueInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_blueColor] width:inkWidth identifier:3];
    yellowInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_yellowColor] width:inkWidth identifier:4];
    
    switch ([activeInkTool identifier])
    {
        case 0:
            [self activateTool:whiteInkTool];
            break;
        case 1:
            [self activateTool:redInkTool];
            break;
        case 2:
            [self activateTool:greenInkTool];
            break;
        case 3:
            [self activateTool:blueInkTool];
            break;
        case 4:
            [self activateTool:yellowInkTool];
            break;
        default:
            break;
    }
    
    inkStyleControl.selectedSegmentIndex = inkStyle;
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

- (void)whiteInkButtonAction:(id)sender
{
    [self activateTool:whiteInkTool];
}

- (void)redInkButtonAction:(id)sender
{
    [self activateTool:redInkTool];
}

- (void)greenInkButtonAction:(id)sender
{
    [self activateTool:greenInkTool];
}

- (void)blueInkButtonAction:(id)sender
{
    [self activateTool:blueInkTool];
}

- (void)yellowInkButtonAction:(id)sender
{
    [self activateTool:yellowInkTool];
}

- (void)eraserButtonAction:(id)sender
{
    [self activateTool:eraserTool];
}

- (void)inkStyleControlAction:(id)sender
{
    self.inkStyle = (MTTutorViewControllerInkStyle)inkStyleControl.selectedSegmentIndex;
}


#pragma mark Private
#pragma mark ---
- (void)activateTool:(PKTool *)tool
{
    if (tool == canvasView.tool)
        return;
    
    whiteInkButton.on = (tool == whiteInkTool);
    redInkButton.on = (tool == redInkTool);
    greenInkButton.on = (tool == greenInkTool);
    blueInkButton.on = (tool == blueInkTool);
    yellowInkButton.on = (tool == yellowInkTool);
    eraserButton.on = (tool == eraserTool);
    
    canvasView.tool = tool;
    
    if ([tool isKindOfClass:[MTInkingTool class]])
        activeInkTool = (MTInkingTool *)tool;
}

@end
