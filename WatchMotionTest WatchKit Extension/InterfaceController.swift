//
//  InterfaceController.swift
//  WatchMotionTest WatchKit Extension
//
//  Created by John Haney on 7/10/15.
//  Copyright © 2015 Lextech. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class InterfaceController: WKInterfaceController {
	let motionManager: CMMotionManager = CMMotionManager()
	let acceleromterQueue: NSOperationQueue = NSOperationQueue()
	
	@IBOutlet var xLabel: WKInterfaceLabel!
	@IBOutlet var yLabel: WKInterfaceLabel!
	@IBOutlet var zLabel: WKInterfaceLabel!

	@IBOutlet var debugLabel: WKInterfaceLabel!
	
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
		self.xLabel.setText("")
		self.yLabel.setText("")
		self.zLabel.setText("")
		self.debugLabel.setText("awake")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
		
		self.debugLabel.setText("willActivate")
		
		self.debugLabel.setText("got CMMotionManager")
		motionManager.startAccelerometerUpdatesToQueue(acceleromterQueue) { (motion: CMAccelerometerData?, error: NSError?) -> Void in
			if error == nil
			{
				self.debugLabel.setText("got motion: \(motion!)")
				self.xLabel.setText("A")
				self.yLabel.setText("B")
				self.zLabel.setText("C")
				if let acceleration = motion?.acceleration				{
					dispatch_async(dispatch_get_main_queue()) {
						self.debugLabel.setText("got motion on main thread: \(motion!)")
						self.xLabel.setText("\(acceleration.x)")
						self.yLabel.setText("\(acceleration.y)")
						self.zLabel.setText("\(acceleration.z)")
					}
				}
			}
			else
			{
				self.debugLabel.setText("got motion error: \(error!)")
			}
		}
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
		motionManager.stopDeviceMotionUpdates()
    }

}
