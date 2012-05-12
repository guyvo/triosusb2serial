/*
 *  globalDefines.h
 *  iLights
 *
 *  Created by Guy Van Overtveldt on 21/12/10.
 *  Copyright 2010 ATOS worldline. All rights reserved.
 *
 */

#define TARGET_IPHONE

// raster view
#ifdef TARGET_IPHONE
    #define RASTER_SIZE         59
    #define RASTER_SPACING      2
    #define FONT_SIZE           6
    #define FONT_SIZE_SLIDERS   13
    #define IMAGE_SCALE_CORTEX  0.5
#else
    #define RASTER_SIZE         136
    #define RASTER_SPACING      10
    #define FONT_SIZE           13
    #define FONT_SIZE_SLIDERS   25
    #define IMAGE_SCALE_CORTEX  1
#endif

#define RASTER_ROWS		5
#define RASTER_COLS		5

#define RASTER_COUNT	RASTER_COLS * RASTER_ROWS

// uitility view
#define UTILITY_COUNT	RASTER_ROWS

// animations
#define RASTER_ANIM_DURATION		2
#define UTILITY_ANIM_DURATION		2
#define SWAP_ANIM_DURATION			1
#define SWIPE_ANIM_DURATION			1
#define SCALE_ANIM_INDICATOR		0.3

#define NUMBER_OF_ONES				20	

// view properties
#define VIEW_CORNER_RADIUS			20
#define VIEW_BORDER_THIKNESS		0.5
#define VIEW_ALPHA_PCBS				0.6

// view tags ids
#define VIEW_TAG_LIGHT_DETAIL		50
#define VIEW_TAG_SAVE_LIGTHS		24
#define VIEW_TAG_LIGHTS_OFF			29

// sliders
#define SLIDERS_LEFT_POS			100
#define SLIDERS_SPACING				100
#define SLIDERS_SCALE				2.2

// strings
#define FILE_NAME_ARCHIVE_INDICATORS	@"lightsindicators.archive"
#define NOTIFICATION_UPDATE				@"updateViews"
#define NOTIFICATION_SAVE_PRESET		@"savePreset"
#define NOTIFICATION_LOAD_PRESET		@"loadPreset"
#define MESSAGE_DETAIL                  @"Cortex detail view"
