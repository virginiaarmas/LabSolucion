//
//  ViewController.h
//  Laboratorio8Solucion
//
//  Created by Virginia Armas on 7/8/13.
//  Copyright (c) 2013 Synergy-GB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableArray *users;
@property (nonatomic, retain) NSMutableString *currentElementValue;

@end
