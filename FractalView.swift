//
//  FractalView.swift
//  Fractal
//
//  Created by Andy Stef on 10/23/16.
//  Copyright © 2016 Andy Stef. All rights reserved.
//

import UIKit

class FractalView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func drawRect(rect: CGRect) {
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMinX(rect), CGRectGetMaxY(rect))
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMidY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect))
        CGContextMoveToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect))
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        CGContextSetFillColorWithColor(ctx, UIColor.blueColor().CGColor)
        CGContextStrokePath(ctx)
        CGContextClosePath(ctx)

    }
}
