//
//  ViewController.swift
//  WatchMotionTest
//
//  Created by John Haney on 7/10/15.
//  Copyright © 2015 Lextech. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, LineChartDelegate {

	let motionManager: CMMotionManager = CMMotionManager()
	let acceleromterQueue: NSOperationQueue = NSOperationQueue()

	@IBOutlet var xyBob: UIView!
	@IBOutlet var zBob: UIView!
	@IBOutlet var xLabel: UILabel!
	@IBOutlet var yLabel: UILabel!
	@IBOutlet var zLabel: UILabel!
	@IBOutlet var debugLabel: UILabel!
    
    var xArray : [CGFloat] = []
    var yArray : [CGFloat] = []
    var zArray : [CGFloat] = []
    
    
    var label = UILabel()
    var lineChart: LineChart!
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var views: [String: AnyObject] = [:]
        
        label.text = "..."
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        views["label"] = label
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[label]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-80-[label]", options: nil, metrics: nil, views: views))
        
        // simple arrays
        var data: [CGFloat] = [3, 4, -2, 11, 13, 15,32,33,43,45,65,34,23,23,45,56,76,78,54,34,23,4,4,5,2,34,23,32,43]
        var data2: [CGFloat] = [1, 3, 5, 13, 17, 20]
        
        // simple line with custom x axis labels
        var xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = false
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        //lineChart.x.labels.values = xLabels
        lineChart.y.labels.visible = true
        lineChart.addLine(data)
        //lineChart.addLine(data2)
        
        //lineChart.add
        
        lineChart.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineChart.delegate = self
        self.view.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[chart]-|", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-[chart(==200)]", options: nil, metrics: nil, views: views))
        
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
                        
                        self.xArray.append(CGFloat(acceleration.x))
                        self.yArray.append(CGFloat(acceleration.y))
                        self.zArray.append(CGFloat(acceleration.z))
                        
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
    
    /**
    * Line chart delegate method.
    */
    func didSelectDataPoint(x: CGFloat, yValues: Array<CGFloat>) {
        label.text = "x: \(x)     y: \(yValues)"
    }
    
    
    
    /**
    * Redraw chart on device rotation.
    */
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }


}

