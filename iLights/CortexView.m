//
//  CortexView.m
//  iLights
//
//  Created by Guy Van Overtveldt on 12/01/11.
//  Copyright 2011 ATOS worldline. All rights reserved.
//

#import "CortexView.h"


@implementation CortexView

- (UILabel *) newLabelWithText:(NSString *) text andWithX:(CGFloat) x andWithY:(CGFloat) y andValue:(int) val{
	
	UILabel * label = [[UILabel alloc]initWithFrame:
					   CGRectMake(x, y, self.bounds.size.width - 5.0, FONT_SIZE)];
	label.text = [NSString stringWithFormat:@"%@ : %d",text,val];
	label.backgroundColor = [UIColor blackColor];
	label.textColor = [UIColor redColor];
	label.adjustsFontSizeToFitWidth = YES;
	label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	label.textAlignment =  UITextAlignmentLeft;
	label.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:FONT_SIZE];
	
	return label;
}

-(id) initWithX:(CGFloat) x andWithY:(CGFloat) y andWithIndex:(NSInteger)index{
	_x = x;
	_y = y;
	_index = index;
	
	return [self initWithFrame:CGRectMake(x, y, 120, 120)];
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		_temperature = [self newLabelWithText:@"temperature" andWithX: 5 andWithY: 10 
									 andValue:gTriosCortexes.cortexes[_index].temperature];
		_dimCount = [self newLabelWithText:@"dimCount" andWithX: 5 andWithY: 30
								  andValue:gTriosCortexes.cortexes[_index].dimmers];
		
		_toggleCount = [self newLabelWithText:@"toggleCount" andWithX: 5 andWithY: 50
									 andValue:gTriosCortexes.cortexes[_index].toggles];
		
		_hoursRun = [self newLabelWithText:@"hoursRun" andWithX: 5 andWithY: 70
								  andValue:gTriosCortexes.cortexes[_index].hours];
		_watchdogCount = [self newLabelWithText:@"watchdogCount" andWithX: 5 andWithY: 90
									   andValue:gTriosCortexes.cortexes[_index].watchdogs];
		
		[self addSubview:_temperature];
		[self addSubview:_dimCount];
		[self addSubview:_toggleCount];
		[self addSubview:_hoursRun];
		[self addSubview:_watchdogCount];
		
		[_temperature release];
		[_dimCount release];
		[_toggleCount release];
		[_hoursRun release];
		[_watchdogCount release];
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
