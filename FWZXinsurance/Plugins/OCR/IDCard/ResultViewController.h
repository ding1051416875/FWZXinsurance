//
//  ResultViewController.h
//  IDCardDemo
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController

@property (strong, nonatomic) NSString *resultString;
@property (strong, nonatomic) NSString *cropImagepath;
@property (strong, nonatomic) NSString *headImagepath;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
