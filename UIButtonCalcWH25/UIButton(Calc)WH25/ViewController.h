//
//  ViewController.h
//  UIButton(Calc)WH25
//
//  Created by Nikolay Berlioz on 22.11.15.
//  Copyright © 2015 Nikolay Berlioz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


- (IBAction)actionNumberIn:(UIButton *)sender;
- (IBAction)actionButtonClear:(UIButton *)sender;
- (IBAction)actionOperator:(UIButton *)sender;
- (IBAction)actionEqual:(UIButton *)sender;
- (IBAction)actionPoint:(UIButton *)sender;
- (IBAction)actionPercent:(UIButton *)sender;
- (IBAction)actionSign:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UILabel *screenLabel;

//button

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *grayButtonCollection;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *blueButtonCollection;

@end

