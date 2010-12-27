//
//  LightView.h
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "triosIncludes.h"

@interface LightView : UIView  {
	
	NSInteger _indexLight;
	
	UILabel * _textDesciption;
	UILabel * _textValue;
	UILabel * _textMin;
	UILabel * _textMax;
	UILabel * _textStep;
	

}
// properties not multithreade and retained after assign
@property (nonatomic,retain) UILabel * _textDesciption;
@property (nonatomic,retain) UILabel * _textValue;
@property (nonatomic,retain) UILabel * _textMin;
@property (nonatomic,retain) UILabel * _textMax;
@property (nonatomic,retain) UILabel * _textStep;
@property (nonatomic) NSInteger _indexLight;

- (id) initWithIndex:(NSInteger)index andFrame:(CGRect)frame;

@end
