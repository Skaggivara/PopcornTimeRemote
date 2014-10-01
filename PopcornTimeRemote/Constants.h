//
//  Constants.h
//  PopcornTimeRemote
//
//  Created by Isak Wiström on 9/23/14.
//  Copyright (c) 2014 skaggivara. All rights reserved.
//

#ifndef PopcornTimeRemote_Constants_h
#define PopcornTimeRemote_Constants_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define contains(str1, str2) ([str1 rangeOfString: str2 ].location != NSNotFound)

#define kPopcornPort 8008
#define kPopcornHost @"http://localhost"
#define kPopcornUser @"popcorn"
#define kPopcornPass @"popcorn"

#define kDefaultColor 0xffffff
#define kSecondaryColor 0x999999
#define kBackgroundColor 0x16171A
#define kActiveColor 0x2B6ED2
#define kOtherActiveColor 0xDE1301

#define kBugFix YES;

#endif
