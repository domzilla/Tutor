//
//  MTTutorViewController.m
//  Tutor
//
//  Created by Dominic Rodemer on 03.08.23.
//

#import "MTTutorViewController.h"

#import "UIColor+Tutor.h"

@interface MTTutorViewController ()

@property (nonatomic, assign) BOOL showsHeadlineTextField;
@property (nonatomic, assign) BOOL showsSubtextField;
 
+ (PKCanvasView *)canvasView;

- (void)nextCanvasView;
- (void)previousCanvasView;

- (void)activateTool:(PKTool *)tool;

- (void)layout;

@end

@implementation MTTutorViewController

#define TTCanvasGridSize 20

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        canvasViews = [NSMutableArray array];
        eraserTool = [[PKEraserTool alloc] initWithEraserType:PKEraserTypeBitmap];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor mt_toolbarColor];
    
    canvasContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    canvasContainerView.backgroundColor = [UIColor mt_canvasBackgroundColor];
    canvasContainerView.layer.masksToBounds = YES;
    [self.view addSubview:canvasContainerView];
        
    canvasGridView = [[UIView alloc] initWithFrame:CGRectZero];
    canvasGridView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"canvas_grid"]];
    [canvasContainerView addSubview:canvasGridView];
    
    headlineTextField = [[MTTextField alloc] initWithFrame:CGRectZero];
    headlineTextField.textFieldDelegate = self;
    headlineTextField.textColor = [UIColor mt_primaryColor];
    headlineTextField.font = [UIFont boldSystemFontOfSize:60.0];
    headlineTextField.minimumFontSize = 30.0;
    headlineTextField.textAttributes = @{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)};
    [canvasContainerView addSubview:headlineTextField];
    
    subtextField = [[MTTextField alloc] initWithFrame:CGRectZero];
    subtextField.textFieldDelegate = self;
    subtextField.textColor = [UIColor mt_primaryColor];
    subtextField.font = [UIFont systemFontOfSize:40.0];
    subtextField.minimumFontSize = 20.0;
    [canvasContainerView addSubview:subtextField];
    
    canvasView = [MTTutorViewController canvasView];
    [canvasContainerView addSubview:canvasView];
    [canvasViews addObject:canvasView];
        
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
    
    toggleSubtextButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"character.textbox"
                                                         withConfiguration:symbolConfiguration]];
    [toggleSubtextButton addTarget:self
                          action:@selector(toggleSubtextButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toggleSubtextButton];
    
    nextCanvasButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"forward.frame"
                                                         withConfiguration:symbolConfiguration]];
    [nextCanvasButton addTarget:self
                         action:@selector(nextCanvasButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextCanvasButton];
    
    previousCanvasButton = [MTButton buttonWithImage:[UIImage systemImageNamed:@"backward.frame"
                                                             withConfiguration:symbolConfiguration]];
    previousCanvasButton.enabled = NO;
    [previousCanvasButton addTarget:self
                             action:@selector(previousCanvasButtonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousCanvasButton];
    
    canvasLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    canvasLabel.textColor = [UIColor mt_tintColor];
    canvasLabel.numberOfLines = 1;
    canvasLabel.textAlignment = NSTextAlignmentCenter;
    canvasLabel.font = [UIFont systemFontOfSize:17.0];
    canvasLabel.minimumScaleFactor = 0.8;
    canvasLabel.adjustsFontSizeToFitWidth = YES;
    canvasLabel.text = @"01/01";
    [self.view addSubview:canvasLabel];
    
    primaryInkButton = [MTButton buttonWithColor:[UIColor mt_primaryColor]];
    [primaryInkButton addTarget:self
                          action:@selector(primaryInkButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:primaryInkButton];
        
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
    
    inkStyleControl = [[MTSegmentedControl alloc] initWithItems:@[[UIImage systemImageNamed:@"scribble"
                                                                          withConfiguration:symbolConfiguration],
                                                                  [UIImage systemImageNamed:@"scribble.variable"
                                                                          withConfiguration:symbolConfiguration],
                                                                  [UIImage systemImageNamed:@"highlighter"
                                                                          withConfiguration:symbolConfiguration]]];
    [inkStyleControl addTarget:self action:@selector(inkStyleControlAction:) forControlEvents:UIControlEventValueChanged];
    inkStyleControl.backgroundColor = [UIColor mt_secondaryBackgroundColor];
    inkStyleControl.layer.borderWidth = 2.0;
    inkStyleControl.layer.borderColor = [[UIColor mt_tintColor] CGColor];
    [self.view addSubview:inkStyleControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.inkStyle = MTTutorViewControllerInkStylePen;
    self.showsHeadlineTextField = YES;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self layout];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? UIStatusBarStyleDarkContent : UIStatusBarStyleLightContent;
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
    
    primaryInkTool = [[MTInkingTool alloc] initWithInkType:inkType
                                                     color:self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ? [UIColor mt_darkPrimaryColor] : [UIColor mt_primaryColor]
                                                     width:inkWidth
                                                identifier:0];
    redInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_redColor] width:inkWidth identifier:1];
    greenInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_greenColor] width:inkWidth identifier:2];
    blueInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_blueColor] width:inkWidth identifier:3];
    yellowInkTool = [[MTInkingTool alloc] initWithInkType:inkType color:[UIColor mt_yellowColor] width:inkWidth identifier:4];
    
    switch ([activeInkTool identifier])
    {
        case 0:
            [self activateTool:primaryInkTool];
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

- (BOOL)showsHeadlineTextField
{
    return showsHeadlineTextField;
}

- (void)setShowsHeadlineTextField:(BOOL)show
{
    showsHeadlineTextField = show;
    toggleHeadlineButton.on = show;
    headlineTextField.alpha = (show ? 1.0 : 0.0);
    headlineTextField.userInteractionEnabled = show;
    [self layout];
}

- (BOOL)showsSubtextField
{
    return showsSubtextField;
}

- (void)setShowsSubtextField:(BOOL)show
{
    showsSubtextField = show;
    toggleSubtextButton.on = show;
    subtextField.alpha = (show ? 1.0 : 0.0);
    subtextField.userInteractionEnabled = show;
    [self layout];
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
    [UIView animateWithDuration:0.5 animations:^{
        self.showsHeadlineTextField = !self->showsHeadlineTextField;
    }];
}

- (void)toggleSubtextButtonAction:(id)sender
{
    [UIView animateWithDuration:0.6 animations:^{
        self.showsSubtextField = !self->showsSubtextField;
    }];
}

- (void)nextCanvasButtonAction:(id)sender
{
    [self nextCanvasView];
}

- (void)previousCanvasButtonAction:(id)sender
{
    [self previousCanvasView];
}

- (void)primaryInkButtonAction:(id)sender
{
    if (headlineTextField.editing)
        headlineTextField.textColor = [UIColor mt_primaryColor];
    else
        [self activateTool:primaryInkTool];
}

- (void)redInkButtonAction:(id)sender
{
    if (headlineTextField.editing)
        headlineTextField.textColor = [UIColor mt_redColor];
    else
        [self activateTool:redInkTool];
}

- (void)greenInkButtonAction:(id)sender
{
    if (headlineTextField.editing)
        headlineTextField.textColor = [UIColor mt_greenColor];
    else
        [self activateTool:greenInkTool];
}

- (void)blueInkButtonAction:(id)sender
{
    if (headlineTextField.editing)
        headlineTextField.textColor = [UIColor mt_blueColor];
    else
        [self activateTool:blueInkTool];
}

- (void)yellowInkButtonAction:(id)sender
{
    if (headlineTextField.editing)
        headlineTextField.textColor = [UIColor mt_yellowColor];
    else
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
+ (PKCanvasView *)canvasView
{
    PKCanvasView *canvasView = [[PKCanvasView alloc] initWithFrame:CGRectZero];
    canvasView.backgroundColor = [UIColor clearColor];
    canvasView.opaque = YES;
    canvasView.drawingPolicy = PKCanvasViewDrawingPolicyPencilOnly;
    canvasView.drawing = [[PKDrawing alloc] init];
    
    return canvasView;
}

- (void)nextCanvasView
{
    NSInteger nextIndex = [canvasViews indexOfObject:canvasView] + 1;
    PKCanvasView *nextCanvasView = nil;
    if (nextIndex < [canvasViews count])
        nextCanvasView = [canvasViews objectAtIndex:nextIndex];
    
    if (!nextCanvasView)
    {
        nextCanvasView = [MTTutorViewController canvasView];
        [canvasViews addObject:nextCanvasView];
    }
    
    nextCanvasView.frame = canvasView.frame;
    nextCanvasView.tool = canvasView.tool;
    [canvasContainerView insertSubview:nextCanvasView aboveSubview:canvasView];
    [canvasView removeFromSuperview];
    canvasView = nextCanvasView;
    
    previousCanvasButton.enabled = YES;
    canvasLabel.text = [NSString stringWithFormat:@"%02ld/%02lu", nextIndex+1, (unsigned long)[canvasViews count]];
}

- (void)previousCanvasView
{
    NSInteger previousIndex = [canvasViews indexOfObject:canvasView] - 1;
    
    if (previousIndex < 0)
        return;
    
    PKCanvasView *previousCanvasView = [canvasViews objectAtIndex:previousIndex];
    previousCanvasView.frame = canvasView.frame;
    previousCanvasView.tool = canvasView.tool;
    [canvasContainerView insertSubview:previousCanvasView aboveSubview:canvasView];
    [canvasView removeFromSuperview];
    canvasView = previousCanvasView;
    
    previousCanvasButton.enabled = previousIndex > 0;
    canvasLabel.text = [NSString stringWithFormat:@"%02ld/%02lu", previousIndex+1, (unsigned long)[canvasViews count]];
}

- (void)activateTool:(PKTool *)tool
{
    if (tool == canvasView.tool)
        return;
    
    primaryInkButton.on = (tool == primaryInkTool);
    redInkButton.on = (tool == redInkTool);
    greenInkButton.on = (tool == greenInkTool);
    blueInkButton.on = (tool == blueInkTool);
    yellowInkButton.on = (tool == yellowInkTool);
    eraserButton.on = (tool == eraserTool);
    
    canvasView.tool = tool;
    
    if ([tool isKindOfClass:[MTInkingTool class]])
        activeInkTool = (MTInkingTool *)tool;
}

- (void)layout
{
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
    
    CGSize headlineSize = [headlineTextField size];
    CGFloat headlineTextFieldHeight = MIN(140.0, MAX(30.0, headlineSize.height)) + 40.0;
    headlineTextField.frame = CGRectMake(0.0,
                                         0.0,
                                         canvasContainerView.frame.size.width,
                                         headlineTextFieldHeight);
    
    CGSize subtextSize = [subtextField size];
    CGFloat subtextFieldHeight = MIN(100.0, MAX(30.0, subtextSize.height)) + 30.0;
    subtextField.frame = CGRectMake(0.0,
                                    showsHeadlineTextField ? headlineTextField.frame.origin.y + headlineTextField.frame.size.height : 0.0,
                                    canvasContainerView.frame.size.width,
                                    subtextFieldHeight);
    
    CGFloat canvasViewY = 0.0;
    if (showsHeadlineTextField)
        canvasViewY = headlineTextField.frame.origin.y + headlineTextField.frame.size.height;
    if (showsSubtextField)
        canvasViewY = subtextField.frame.origin.y + subtextField.frame.size.height;
    canvasView.frame = CGRectMake(0.0,
                                  canvasViewY,
                                  canvasContainerView.frame.size.width,
                                  canvasContainerView.frame.size.height);
    
    
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
    toggleSubtextButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    
    buttonOrigin.x = topToolbarFrame.size.width - buttonSize.width - offset;
    nextCanvasButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    buttonOrigin.x -= 60.0;
    canvasLabel.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, 60.0, buttonSize.height);
    buttonOrigin.x -= buttonSize.width;
    previousCanvasButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
    
    buttonOrigin = CGPointMake(offset, bottomToolbarFrame.origin.y + floorf(bottomToolbarFrame.size.height/2 - buttonSize.height/2));
    primaryInkButton.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
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



#pragma mark MTTextFieldDelegate
#pragma mark ---
- (void)textFieldNeedsLayout:(MTTextField *)textField
{
    [self layout];
}


@end
