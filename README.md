# MKStarRatingView

MKStarRatingView is subclass of UIControl that gives star rating output view, whihc is written in swift language.
MKStarRatingView allows you to select a rating from 0 to any number of stars you want.
You can set any custom images and fill colors instead of stars for rating.

# Get Started

Add MKStarRatingView.swift to your project.

### How to use this ?

        let ratingView : MKStarRatingView = MKStarRatingView(frame: CGRectMake(50  , 200, 200, 50))
        ratingView.backgroundColor = UIColor.whiteColor()  // The view background color, by default it is clear color
        ratingView.normalStarImage = UIImage(named: "star-template")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) // This is mandatory, will considering the shape for outlined rating element.
        ratingView.highlightedStarImage = UIImage(named: "star-highlighted-template")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate) // This is mandatory, will considering the shape for Filled rating element.
        ratingView.supportPartialFill = true // By default it is false, this is basically while tapping the star for rating partial value (above 0.7% will consider as full star selection)
        ratingView.maxRatingStars = 5 // Space between stars will vary based on width of the view 
        ratingView.enableTouch = true // BY default it is false
        ratingView.rating = 2.5
        ratingView.delegate = self
        self.view.addSubview(ratingView);
        ratingView.setNeedsDisplay()

# ARC
MKStarRatingView uses ARC.

# License
MKStarRatingView is available under the MIT license. See the LICENSE file for more info.
