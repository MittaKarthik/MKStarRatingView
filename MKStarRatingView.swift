//
//  MKStarRatingView.swift
//  MKStarReviewDemoApp
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 Karthik Mitta
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit

protocol MKStarRatingDelegate
{
    func selectedStarRating(rating: Float)
}

class MKStarRatingView: UIControl {

    struct MKStarRatingConstants
    {
        static let sapceBetweenStars: CGFloat = 10
    }
    
    
    
    // MARK: -  Public Properties
    var backgroundImage : UIImage!
    var maxRatingStars : NSInteger!
    var enableTouch : Bool!
    var delegate : MKStarRatingDelegate?
    var starBorderColor : UIColor?
    var starSelectionColor : UIColor?
    var supportPartialFill : Bool = false
    
    // MARK: -  Private Properties
    private var tintStarImage : UIImage!
    private var tintHighlightedStarImage : UIImage!
    private var seletedRating : Float!

    
    // MARK: -  Initializers
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        assignDefaultProperties()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        assignDefaultProperties()
    }
    
    func assignDefaultProperties()
    {
        self.maxRatingStars = 5
        self.rating = 0.0
        self.enableTouch = true;
        self.starBorderColor = UIColor.lightGrayColor()
        self.starSelectionColor = UIColor.orangeColor()
        self.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Setters
    
    var rating: Float?
    {
        willSet(newRating)
        {
            
        }
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var normalStarImage: UIImage?
    {
        willSet(newImage)
        {
            
        }
        didSet {
            
            self.tintStarImage = self.getTintedImage(normalStarImage!, fillColor: self.starBorderColor!)
            self.setNeedsDisplay()
        }
    }
    
    var highlightedStarImage: UIImage?
    {
        willSet(newImage)
        {
            
        }
        didSet {
            
            self.tintHighlightedStarImage = self.getTintedImage(highlightedStarImage!, fillColor: self.starSelectionColor!)
            self.setNeedsDisplay()
        }
    }

  
    // Mark: - Custom Drawing Methods
    
    func getPositionOfStar(positionIndex: NSInteger, highlighted:Bool) -> CGPoint
    {
        let starSize  : CGSize = highlighted ? self.normalStarImage!.size : self.highlightedStarImage!.size
        
        var xPos : CGFloat = 0
        let yPos : CGFloat = 0
        
        let calculatedSpace : CGFloat = (self.bounds.size.width - (CGFloat(self.maxRatingStars) * starSize.width))/CGFloat(self.maxRatingStars - 1)
        
        if positionIndex > 0
        {
            xPos = (starSize.width + calculatedSpace) * CGFloat(positionIndex)
        }
        return CGPointMake(xPos, yPos)
    }
    
    
    // This method will draw the image at particular position based on user tocuh response
    
    func drawStarImage(image: UIImage, position: NSInteger)
    {
        image.drawAtPoint(getPositionOfStar(position, highlighted: true))
    }

    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let currentContext:CGContextRef = UIGraphicsGetCurrentContext()!
        
        // Fill the background color 
        CGContextSetFillColorWithColor(currentContext, self.backgroundColor?.CGColor)
        CGContextFillRect(currentContext, self.bounds)
        
        // Draw the background image, when there is a background image
        if let bgImage = self.backgroundImage
        {
            bgImage.drawInRect(self.bounds)
        }
        
        // Then need to draw rating images
        let starImageSize : CGSize  = self.highlightedStarImage!.size
        
        for index in 0...self.maxRatingStars-1
        {
            self.drawStarImage(self.tintStarImage, position: index)
            if Float(index) < self.rating
            {
                CGContextSaveGState(currentContext)
                if self.rating <  Float(index+1)
                {
                    let starPosition : CGPoint = self.getPositionOfStar(index, highlighted: false)
                    let ratingDifference : CGFloat = CGFloat(self.rating!) - CGFloat(index)
                    var starClipRect : CGRect = CGRect()
                    starClipRect.origin = starPosition
                    starClipRect.size = starImageSize
                    starClipRect.size.width *= ratingDifference
                    
                    if starClipRect.size.width > 0
                    {
                        CGContextClipToRect(currentContext, starClipRect)
                    }
                }
                self.drawStarImage(self.tintHighlightedStarImage, position: index)
                CGContextRestoreGState(currentContext)
            }
        }
        
    }
    
    
    // Mark: - Tint color image composing methods
    
    func getTintedImage(image : UIImage, fillColor : UIColor) -> UIImage
    {
        var tintedImage : UIImage = image;
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextTranslateCTM(context, 0, image.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        let rect: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        // draw alpha-mask
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextDrawImage(context, rect, image.CGImage)
        // draw tint color, preserving alpha values of original image
        CGContextSetBlendMode(context, CGBlendMode.SourceIn)
        fillColor.setFill()
        CGContextFillRect(context, rect)
        tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
    
    // If user changed the tint color of self object then need to update the view
    
    override func tintColorDidChange() {
        if self.normalStarImage != nil
        {
            self.tintStarImage = self.getTintedImage(self.normalStarImage!, fillColor: self.starBorderColor!)
            if self.highlightedStarImage != nil
            {
                self.tintHighlightedStarImage = self.getTintedImage(self.highlightedStarImage!, fillColor:self.starSelectionColor!)
            }
            self.setNeedsDisplay()

        }
    }
    
    
    //MARK: - Touch interaction methods
    
    func getStarValueAtPosition(point:CGPoint) -> Float
    {
        var starValue : Float = 0
        
        for index in 0...self.maxRatingStars-1
        {
            let starPoint : CGPoint = self.getPositionOfStar(index, highlighted: false)
            
            if  point.x > starPoint.x
            {
                var increment : Float = 1.0

                let difference : Float = Float((point.x - starPoint.x)/self.normalStarImage!.size.width);
                if( difference < 0.7 && self.supportPartialFill == true)
                {
                    increment=difference;
                }
                starValue += increment;
            }
        }
        return starValue
    }
    
    
     override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.checkTheTouchPoint(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
       self.checkTheTouchPoint(touches)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.enableTouch == false
        {
            return
        }
    
        if(self.delegate != nil && self.delegate?.selectedStarRating != nil)
        {
            self.delegate?.selectedStarRating(self.rating!)
        }
    }
    
    func checkTheTouchPoint(touches: Set<UITouch>)
    {
        if self.enableTouch == false
        {
            return
        }
        
        if let touch: UITouch = touches.first
        {
            let touchLocation : CGPoint = touch.locationInView(self)
            self.rating = self.getStarValueAtPosition(touchLocation)
            self.setNeedsDisplay()
        }
    }

}
