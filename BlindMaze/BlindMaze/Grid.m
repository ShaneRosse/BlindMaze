//
//  Grid.m
//  BlindMaze
//
//  Created by Faraz Abidi on 1/24/15.
//  Copyright (c) 2015 Shane Rosse. All rights reserved.
//

#import "Grid.h"
#import "PixelPoint.h"

@implementation Grid

/*Ask shane about initialization
 1) we need to set isLeft
 2) we can optionally include an array of pixelPoints
 Is lazy instantiation necessary?
 */

-(int)playersTouchX:(int)x TouchY:(int)y wasATap:(bool)tap{
    bool start;
    if(self.isLeft)
        start = (x < 100 && x > 75 && y < 10 && y > 0); //change according to values of box
    else
        start = (x < 100 && x > 75 && y > 700); //change according to values of box. X boundaries should be the same
    
    if (start) self.hasCollided = false;
    if((tap && !start) || self.hasCollided){
        return 1; //invalid move; phone should produce sound
    }
    else if (( y > 480 &&self.isLeft) || (y< 520 && !self.isLeft)) //change according to victory boundaries
        return 2;
    else{
        return [self checkCollisionTouchX:x TouchY:y];
    }
    
    
}

-(bool) addPixelPoint:(PixelPoint *)newPoint{
    for (PixelPoint *p in self.pixelPointsArray)
        if([newPoint isNearOtherPoint:p inRadius:self.ppDistance])
            return false;
    [self.pixelPointsArray addObject:newPoint];
    return true;
}

/*
 Pixel Points array actually determines safe zone
 outside their radius is a collision
 */
-(bool) pixelCollides:(PixelPoint *)yourPoint givenRadius:(int)collisionRad{
    for (PixelPoint *p in self.pixelPointsArray)
        if([yourPoint isNearOtherPoint:p inRadius:collisionRad])
            return false;
        else{
            return true;
        }
    NSLog(@"Error: PixelPoints array is empty");
    return true;
}


/*
 remember to set hasCollided in this method
 */
-(int) checkCollisionTouchX:(int)x TouchY:(int)y{
    PixelPoint * curPoint; //TODO: create new PixelPoints object out of x and y
    if([self pixelCollides:curPoint givenRadius:self.safetyRad]){
        self.hasCollided = true;
        return 1;
    }
    else return 0;
}

@end
