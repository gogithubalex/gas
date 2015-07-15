//
//  ViewController.swift
//  BatonGestures
//
//  Created by Alex Decker on 7/11/15.
//  Copyright © 2015 Alex Decker. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let macHost = "10.0.1.18"
	
    let motionManager: CMMotionManager = CMMotionManager()
    let acceleromterQueue: NSOperationQueue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        acceleromterQueue.maxConcurrentOperationCount = 1
        
        
        let connection = NSURLSession.sharedSession()
        
//        let url = "http://\(harmonHost):8080/v1/init_session"
//		
//        let request = NSURLRequest(URL: NSURL(string: url)!)
//        print(request)
//        
//        let initTask = connection.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
//            
//            if let e = error {
//                print("\(e)")
//            } else {
//                do {
//                    print("\(data)")
//                    
//                    let parsedObject: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!,
//                        options: NSJSONReadingOptions.AllowFragments)
//                    
//                    if let json = parsedObject as? NSDictionary {
//                        print("\(json)")
//                        self.sessionId = NSNumberFormatter().numberFromString(json["SessionID"] as! String)!.integerValue
//                    }
//                } catch {
//                    print(error)
//                }
//                
//            }
//        }
//        initTask?.resume();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pushDown(sender: AnyObject) {
        startMotionUpdates()
    }
    @IBAction func pushUp(sender: AnyObject) {
        endMotionUpdates()
    }
    
    
    func didGoUp(attitude : CMAttitude) {
        let connection = NSURLSession.sharedSession()
        
        let url = "http://\(macHost):8080/firework?attitude=\(attitude.pitch),\(attitude.yaw),\(attitude.roll)"
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        print(request)
        
        let uploadTask = connection.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            if let e = error {
                print("\(e)")
            }
        }
        uploadTask?.resume();
    }
    
    func didGoDown() {
        print("down")
    }
    
    var sessionId = 1000
    let persistentId : Int64 = 84583182803994709
	
	func didGoLeft() {
		let connection = NSURLSession.sharedSession()
		
		let url = "http://\(macHost):8080/speaker"
		
		let request = NSURLRequest(URL: NSURL(string: url)!)
		print(request)
		
		let uploadTask = connection.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
			
			if let e = error {
				print("\(e)")
			}
		}
		uploadTask?.resume();
	}
	
//    func didGoLeft() {
//        let connection = NSURLSession.sharedSession()
//
//        let url2 = "http://\(harmonHost):8080/v1/play_hub_media?SessionID=\(sessionId)&PersistentID=\(persistentId)"
//        
//        let request = NSURLRequest(URL: NSURL(string: url2)!)
//        let playTask = connection.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
//            
//            if let e = error {
//                print("\(e)")
//            }
//        }
//        playTask?.resume()
//        
//        let url3 = "http://\(macHost):8080/speaker"
//    
//        let showSpeakerRequest = NSURLRequest(URL: NSURL(string: url3)!)
//        let showSpeakerTask = connection.dataTaskWithRequest(showSpeakerRequest) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
//            
//            if let e = error {
//                print("\(e)")
//            }
//        }
//        showSpeakerTask?.resume()
//    }
	
    func didGoRight() {
        let url = "https://meshblu.octoblu.com/messages"
        //let url = "http://google.com"
        let connection = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.addValue("c86b7833-c417-4ab7-8be0-ca6345a02428", forHTTPHeaderField: "meshblu_auth_uuid")
        request.addValue("a38cd815724c7aab7411da2105337848dc947a1a", forHTTPHeaderField: "meshblu_auth_token")
        
        let message = "Hi Town Hall, from our iosdevcamp project \(NSDate()) "
        let payload = "{\"devices\":\"*\",\"payload\":{\"status\":\"\(message)\"}}"

        
        let tweetTask = connection.uploadTaskWithRequest(request, fromData:payload.dataUsingEncoding(NSUTF8StringEncoding)!) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            print(NSString(data:data!, encoding:NSUTF8StringEncoding))
            if let e = error {
                print("\(e)")
            }
        }
        tweetTask?.resume()
        
        
        let url4 = "http://\(macHost):8080/tweet"
        
        let tweetRefreshRequest = NSURLRequest(URL: NSURL(string: url4)!)
        let tweetRefreshTask = connection.dataTaskWithRequest(tweetRefreshRequest) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            if let e = error {
                print("\(e)")
            }
        }
        tweetRefreshTask?.resume()
    }
    
    func endMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    var count = 0;
    
    var didFire = false;
    
    func startMotionUpdates() {
        didFire = false
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(motionManager.attitudeReferenceFrame,
            toQueue:acceleromterQueue) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
                if error == nil
                {
                    if let attitude = motion?.attitude {
                        //print("\(attitude.description)")
//                        print("   value (\(attitude.pitch)) (\(attitude.yaw))")
                        
                        if(self.count++ % 10 == 0)
                        {
                            self.sendAttitudeToServer(attitude)
                        }
                        
                        if(!self.didFire && attitude.pitch > M_PI_4)
                        {
                            print("\(attitude.pitch)")
                            self.didGoUp(attitude)
                            self.didFire = true;
                        }
                        else if(!self.didFire && attitude.pitch < -M_PI_4/2)
                        {
                            print("\(attitude.pitch)")
                            self.didGoDown()
                            self.didFire = true;
                        }
                        else if(!self.didFire && attitude.yaw > M_PI_4 )
                        {
                            print("\(attitude.yaw)")
                            self.didGoLeft()
                            self.didFire = true;
                        }
                        else if(!self.didFire && attitude.yaw < -M_PI_4)
                        {
                            print("\(attitude.yaw)")
                            self.didGoRight()
                            self.didFire = true;
                        }
                        else
                        {
                            if(abs(attitude.pitch) <  M_PI/12.0 && abs(attitude.yaw) <  M_PI/12.0)
                            {
                                self.didFire = false;
//                                print("")
//                                print("home (\(attitude.pitch)) (\(attitude.yaw))")
                            }
                        }
                        
                    }
                }
        }
    }
    
    
    func sendAttitudeToServer(attitude : CMAttitude)
    {
        let connection = NSURLSession.sharedSession()

        let url = "http://\(macHost):8080/attitude?attitude=\(attitude.pitch),\(attitude.yaw),\(attitude.roll)"
        
        let request = NSURLRequest(URL: NSURL(string: url)!)
        print(request)
        
        let uploadTask = connection.dataTaskWithRequest(request) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            if let e = error {
                print("\(e)")
            }
        }
        uploadTask?.resume();
    }

}

