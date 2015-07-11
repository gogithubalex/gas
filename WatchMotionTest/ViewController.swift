//
//  ViewController.swift
//  WatchMotionTest
//
//  Created by John Haney on 7/10/15.
//  Copyright © 2015 Lextech. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

	let motionManager: CMMotionManager = CMMotionManager()
	let acceleromterQueue: NSOperationQueue = NSOperationQueue()

	@IBOutlet var xyBob: UIView!
	@IBOutlet var zBob: UIView!
	@IBOutlet var xLabel: UILabel!
	@IBOutlet var yLabel: UILabel!
	@IBOutlet var zLabel: UILabel!
	@IBOutlet var debugLabel: UILabel!
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.debugLabel.text = "willActivate"
		
		self.debugLabel.text = "got CMMotionManager"
		
//		doAccelerometerUpdates()
		doMotionUpdates()
	}
	
	func doAccelerometerUpdates() {
		motionManager.startAccelerometerUpdatesToQueue(acceleromterQueue) { (motion: CMAccelerometerData?, error: NSError?) -> Void in
			if error == nil
			{
				self.debugLabel.text = "got motion: \(motion!)"
				if let acceleration = motion?.acceleration				{
					dispatch_async(dispatch_get_main_queue()) {
						self.debugLabel.text = "got motion on main thread: \(motion!)"
						self.xLabel.text = "\(acceleration.x)"
						self.yLabel.text = "\(acceleration.y)"
						self.zLabel.text = "\(acceleration.z)"
					}
				}
			}
			else
			{
				self.debugLabel.text = "got motion error: \(error!)"
			}
		}
	}
	
	func doMotionUpdates() {
		motionManager.startDeviceMotionUpdatesToQueue(acceleromterQueue) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
			if error == nil
			{
				if let acceleration = motion?.userAcceleration {
					dispatch_async(dispatch_get_main_queue()) {
						self.xLabel.text = "\(acceleration.x)"
						self.yLabel.text = "\(acceleration.y)"
						self.zLabel.text = "\(acceleration.z)"
						
							self.xyBob.center = CGPoint(x: 150 + acceleration.x * 100, y: 150 + acceleration.y * 100)
							self.zBob.center = CGPoint(x: 10, y: 150 + acceleration.z * 100)
					}
				}
			}
			else
			{
				self.debugLabel.text = "got motion error: \(error!)"
			}
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

