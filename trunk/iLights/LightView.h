//
//  LightView.h
//  iLights
//
//  Created by Guy Van Overtveldt on 27/11/10.
//  Copyright 2010 ATOS worldline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "triosIncludes.h"

@interface LightView : UIView {
	UILabel * _textDesciption;
	UILabel * _textValue;

}
// properties not multithreade and retained after assign
@property (nonatomic,retain) UILabel * _textDesciption;
@property (nonatomic,retain) UILabel * _textValue;

@end
