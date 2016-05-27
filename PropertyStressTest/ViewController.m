//
//  ViewController.m
//  PropertyStressTest
//
//  Created by David Bireta on 5/27/16.
//  Copyright © 2016 Mediafly. All rights reserved.
//

#import "ViewController.h"
#import "SampleClass.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t backgroundQueue;
@property (nonatomic, strong) dispatch_queue_t anotherBackgroundQueue;
@property (nonatomic, strong) SampleClass *sampleTester;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundQueue = dispatch_queue_create("com.mediafly.proptest-one", DISPATCH_QUEUE_SERIAL);
    self.anotherBackgroundQueue = dispatch_queue_create("com.mediafly.proptest-two", DISPATCH_QUEUE_SERIAL);
    self.sampleTester = [[SampleClass alloc] init];
    
    dispatch_async(self.backgroundQueue, ^{
        NSAssert(![NSThread isMainThread], @"This should be a background thread (handled by dispatch queue)");
        
        for (int i=0; i<10000; i++) {
            NSLog(@"Setting value to 3");
            self.sampleTester.someInteger = 3;
            
            self.sampleTester.someString = @"Donatello";
        }
    });
    
    dispatch_async(self.anotherBackgroundQueue, ^{
        NSAssert(![NSThread isMainThread], @"This should be a background thread (handled by dispatch queue)");
        
        for (int i=0; i<10000; i++) {
            NSLog(@"Setting value to 4");
            self.sampleTester.someInteger = 4;
            
            self.sampleTester.someString = @"Raphael";
        }
    });
    
    for (int i=0; i<10000; i++) {
        NSLog(@"The value of `someInteger` is: %li", (long)self.sampleTester.someInteger);
        
        NSLog(@"The value of `someString` is %@", self.sampleTester.someString);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
