#import <Foundation/Foundation.h>

typedef enum Side {
    Left,
    Right,
    Top,
    Bottom
} Side;

@interface Forest : NSObject
{
    NSArray<NSNumber*>* trees;
    uint sideLength;
}
+ (Forest*)initFromInput:(NSString*)input;
- (void)run;
@end

@implementation Forest
+ (Forest*)initFromInput:(NSString*)input
{
    Forest* forest = [[Forest alloc] init];
    NSArray* lines = [input componentsSeparatedByString:@"\n"];
    NSMutableArray* trees = [NSMutableArray array];
    for (NSString* line in lines) {
        for (uint i = 0; i < line.length; i++) {
            [trees addObject:@([line characterAtIndex:i] - '0')];
        }
    }
    forest->trees = trees;
    forest->sideLength = [lines[0] length];
    return forest;
}
- (NSInteger)getTreeAtX:(NSInteger)x y:(NSInteger)y
{
    return [trees[(NSUInteger) y * sideLength + (NSUInteger) x] integerValue];
}
- (bool)checkVisibility:(Side)side x:(NSInteger)x y:(NSInteger)y score:(NSInteger*)score {
    *score = 0;
    NSInteger tree = [self getTreeAtX:x y:y];
    while (true) {
        switch (side) {
            case Left:
                x--;
                break;
            case Right:
                x++;
                break;
            case Top:
                y--;
                break;
            case Bottom:
                y++;
                break;
        }

        if (x < 0 || x == sideLength || y < 0 || y == sideLength ) {
            return false;
        }

        *score += 1;

        if ([self getTreeAtX:x y:y] >= tree) {
            return true;
        }
    }
}
- (void)run {
    NSInteger count = 0;
    NSInteger bestScore = 0;
    for (NSUInteger x = 0; x < sideLength; x++) {
        for (NSUInteger y = 0; y < sideLength; y++) {
            NSInteger leftScore;
            NSInteger rightScore;
            NSInteger topScore;
            NSInteger bottomScore;

            bool visible = [self checkVisibility:Left x:x y:y score:&leftScore]
                         | [self checkVisibility:Right x:x y:y score:&rightScore]
                         | [self checkVisibility:Top x:x y:y score:&topScore]
                         | [self checkVisibility:Bottom x:x y:y score:&bottomScore];

            if (visible) {
                count += 1;
            }

            NSInteger score = leftScore * rightScore * topScore * bottomScore;
            if (score > bestScore) {
                bestScore = score;
            }
        }
    }
    NSLog(@"Total visible trees: %ld", count);
    NSLog(@"Best score: %ld", bestScore);
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 2) {
            NSLog(@"Usage: day7 <input file>");
            return 1;
        }
        NSString* filename = [NSString stringWithUTF8String:argv[1]];
        NSString* input = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
        Forest* forest = [Forest initFromInput:input];
        [forest run];
    }
    return 0;

}