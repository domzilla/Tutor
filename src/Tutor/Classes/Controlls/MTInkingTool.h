//
//  MTInkingTool.h
//  Tutor
//
//  Created by Dominic Rodemer on 09.08.23.
//

#import <PencilKit/PencilKit.h>

@interface MTInkingTool : PKInkingTool

@property (nonatomic, assign, readonly) NSInteger identifier;

- (id)initWithInkType:(PKInkType)type color:(UIColor *)color width:(CGFloat)width identifier:(NSInteger)identifier;

@end
