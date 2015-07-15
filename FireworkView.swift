//
//  FireworkView.swift
//  QuadGas
//
//  Created by Alex Decker on 7/11/15.
//  Copyright © 2015 Alex Decker. All rights reserved.
//

import Foundation


//
//  FL_FireworkView.m
//  Flashlight
//
//  Created by John Haney on 5/27/12.
//  Copyright (c) 2012 John Haney Software LLC. All rights reserved.
//

import AppKit
import QuartzCore
class FireworkLauncher {

    func mortor() -> CAEmitterLayer {
        //Load the spark image for the particle
        
        let mortor = CAEmitterLayer();
        //    mortor.emitterPosition = CGPointMake(self.bounds.size.width/2, self.bounds.size.height*(.75));
        mortor.emitterPosition = CGPointMake(0, 0);
        
        mortor.renderMode = kCAEmitterLayerAdditive;
        mortor.birthRate = 0.5;
        
        //Invisible particle representing the rocket before the explosion
        let rocket = CAEmitterCell();
        rocket.emissionLongitude = CGFloat(M_PI) / 2;
        rocket.emissionLatitude = 0;
        rocket.lifetime = 1.6;
        //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        //        {
        rocket.birthRate = 2;
        rocket.velocity = 600;
        rocket.velocityRange = 400;
        rocket.yAcceleration = -500;
        rocket.emissionRange = CGFloat(M_PI) / 4;
        //        }
        //        else
        //        {
        //            rocket.birthRate = 1;
        //            rocket.velocity = self.bounds.size.height * 0.8333333333333;
        //            rocket.velocityRange = 100;
        //            rocket.yAcceleration = self.bounds.size.height * 0.5208333333333;
        //            if (self.bounds.size.height > 480)
        //            {
        //                rocket.emissionRange = M_PI / 6;
        //            }
        //            else
        //            {
        //                rocket.emissionRange = M_PI / 4;
        //            }
        //        }
        
        rocket.color = NSColor(calibratedRed:0.5, green:0.5, blue:0.5, alpha:0.5).CGColor;
        rocket.redRange = 0.5;
        rocket.greenRange = 0.5;
        rocket.blueRange = 0.5;
        
        //Name the cell so that it can be animated later using keypath
        rocket.name = "rocket";
        
        //Flare particles emitted from the rocket as it flys
        let flare = CAEmitterCell();
        
        
        //let image = NSImage(named:"spark")
        
        //let tiff = image?.TIFFRepresentation
        
        //let source = CGImageSourceCreateWithData(tiff as! CFDataRef, nil)
        
        let image = NSImage(named:"spark")!
        var imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let imageRef :CGImage = image.CGImageForProposedRect(&imageRect, context: nil, hints: nil)!.takeUnretainedValue()
        

        //let imageRef = CGImageSourceCreateImageAtIndex(source!, 0, nil);
        flare.contents = imageRef
        flare.emissionLongitude = (4 * CGFloat(M_PI)) / 2;
        flare.scale = 0.4;
        flare.velocity = 100;
        flare.birthRate = 45;
        flare.lifetime = 1.5;
        flare.yAcceleration = 350;
        flare.emissionRange = CGFloat(M_PI) / 7;
        flare.alphaSpeed = -0.7;
        flare.scaleSpeed = -0.1;
        flare.scaleRange = 0.1;
        flare.beginTime = 0.01;
        flare.duration = 0.7;
        
        //The particles that make up the explosion
        let firework = CAEmitterCell()
        firework.contents = imageRef
        firework.birthRate = 9999;
        //        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        //        {
        firework.scale = 0.6;
        firework.velocity = 390;
        firework.yAcceleration = 240;
        //        }
        //        else
        //        {
        //            firework.scale = 0.6;
        //            firework.velocity = 130;
        //            firework.yAcceleration = 80;
        //        }
        firework.lifetime = 2;
        firework.alphaSpeed = -0.2;
        firework.beginTime = 1.5;
        firework.duration = 0.1;
        firework.emissionRange = 2 * CGFloat(M_PI);
        firework.scaleSpeed = -0.1;
        firework.spin = 2;
        
        //Name the cell so that it can be animated later using keypath
        firework.name = "firework"
        
        //preSpark is an invisible particle used to later emit the spark
        let preSpark = CAEmitterCell();
        preSpark.birthRate = 80;
        preSpark.velocity = firework.velocity * 0.70;
        preSpark.lifetime = 1.7;
        preSpark.yAcceleration = firework.yAcceleration * 0.85;
        preSpark.beginTime = firework.beginTime - 0.2;
        preSpark.emissionRange = firework.emissionRange;
        preSpark.greenSpeed = 100;
        preSpark.blueSpeed = 100;
        preSpark.redSpeed = 100;
        
        //Name the cell so that it can be animated later using keypath
        preSpark.name = "preSpark";
        
        //The 'sparkle' at thaSeconde end of a firework
        let spark = CAEmitterCell();
        spark.contents = image
        spark.lifetime = 0.05;
        spark.yAcceleration = 250;
        spark.beginTime = 0.8;
        spark.scale = 0.4;
        spark.birthRate = 10;
        
        preSpark.emitterCells = [spark];
        rocket.emitterCells = [flare, firework, preSpark];
        mortor.emitterCells = [rocket];
        
        return mortor;
    }
}