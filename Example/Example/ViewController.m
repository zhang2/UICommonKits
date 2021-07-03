//
//  ViewController.m
//  Example
//
//  Created by zjg on 7/3/21.
//

#import "ViewController.h"
#import <ZJGPrintTool.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ZJGPrintTool randomColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.view.backgroundColor = [ZJGPrintTool randomColor];
}


@end
