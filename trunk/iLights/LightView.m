//
//  LightView.m
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import "LightView.h"


@implementation LightView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor blackColor];
		self.layer.borderColor =[[UIColor redColor]CGColor];
		self.layer.cornerRadius = 30;
		self.layer.borderWidth = 2;
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
