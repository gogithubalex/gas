//
//  ViewController.swift
//  QuadGas
//
//  Created by Alex Decker on 7/11/15.
//  Copyright © 2015 Alex Decker. All rights reserved.
//

import Cocoa
import SceneKit
import WebKit
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var speakerView: NSView!
    
    @IBOutlet weak var speakerImage: NSImageView!
    
    @IBOutlet weak var twitterView: WebView!
    
    @IBOutlet weak var fireworkBackground: NSView!
    @IBOutlet weak var fireworkView: NSView!
    let mortor = FireworkLauncher().mortor()
    
    let twitterUrl = "http://localhost:8082/tst.html"
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene = SCNScene(named: "Orientation.scn");
        
        speakerView.layer = CALayer()
        speakerView.layer?.backgroundColor = NSColor.whiteColor().CGColor
        speakerView.wantsLayer = true;
        
        fireworkBackground.layer = CALayer()
        fireworkBackground.layer?.backgroundColor = NSColor.whiteColor().CGColor
        fireworkBackground.wantsLayer = true;
        
        
        let box = sceneView.scene?.rootNode.childNodeWithName("box", recursively: true)
        
        self.fireworkView.layer = self.mortor;
        
        self.fireworkView.wantsLayer = true;
        self.mortor.birthRate = 0
        
        //NSURL*url=[NSURL URLWithString:@"http://www.google.com"];
        //NSURLRequest*request=[NSURLRequest requestWithURL:url];
        
        
        let request = NSURLRequest(URL:NSURL(string:twitterUrl)!)
        self.twitterView.mainFrame.loadRequest(request)
        
        //fireworkView.layer?.backgroundColor = NSColor.redColor().CGColor
        
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gong", ofType: "mp3")!)
        print(alertSound)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: alertSound)
            audioPlayer.prepareToPlay()
        } catch {
            
        }
        
        
        // Insert code here to initialize your application
        let server = HttpServer()
        server["/attitude"] = {
            //print("\($0.body)");
            
            
            let parsedUrl = NSURL(string:$0.url)
            if let attitude :String = parsedUrl?.query?.componentsSeparatedByString("=")[1] {
                let attitudeComps = attitude.componentsSeparatedByString(",")
  
                let pitch = NSNumberFormatter().numberFromString(attitudeComps[0])!.doubleValue
                let yaw = NSNumberFormatter().numberFromString(attitudeComps[1])!.doubleValue
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let transform = SCNMatrix4Mult(SCNMatrix4MakeRotation(CGFloat(pitch), CGFloat(1.0), CGFloat(0), CGFloat(0)),
                        SCNMatrix4MakeRotation(CGFloat(yaw), CGFloat(0), CGFloat(1.0), CGFloat(0)))
                    
                    let spin = CABasicAnimation(keyPath: "transform")
                    // Use from-to to explicitly make a full rotation around z
                    spin.fromValue = NSValue(SCNMatrix4: box!.transform)
                    spin.toValue = NSValue(SCNMatrix4: transform)
                    spin.duration = 0.1
                    box?.addAnimation(spin, forKey: "spin around")
                    
                    box?.transform = transform
                    
                })
                
                
            }
            
            return .OK(.HTML("You asked for " + $0.url))
        }
        
        server["/firework"] = {
            print("firework")
            
            let parsedUrl = NSURL(string:$0.url)
            if let attitude :String = parsedUrl?.query?.componentsSeparatedByString("=")[1] {
                let attitudeComps = attitude.componentsSeparatedByString(",")
                
                let pitch = NSNumberFormatter().numberFromString(attitudeComps[0])!.doubleValue
                let yaw = NSNumberFormatter().numberFromString(attitudeComps[1])!.doubleValue
                let roll = NSNumberFormatter().numberFromString(attitudeComps[2])!.doubleValue
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    self.mortor.emitterPosition = CGPoint(x:CGFloat((-yaw + M_PI_2)/M_PI) * self.fireworkView.frame.width, y:0)
                    
                    print(roll  + M_PI_2)
                    
                    //self.mortor.emitterCells?.first?.emissionLongitude = CGFloat(-roll  + M_PI_2)
                    //self.mortor.emitterCells?.first?.emissionRange = 0
                    
                    self.mortor.birthRate = 0.25
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                        self.mortor.birthRate = 0
                    }
                
                })
                
                
            }
            
            return .OK(.HTML("You asked for " + $0.url))
        }
        
        server["/speaker"] = {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.audioPlayer.play()
                self.speakerImage.image = NSImage(named: "audio_on")
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(7.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
                    self.speakerImage.image = NSImage(named: "audio_off")
                }
                
            })
            
            return .OK(.HTML("You asked for " + $0.url))
        }
        
        server["/tweet"] = {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                let request = NSURLRequest(URL:NSURL(string:self.twitterUrl)!)
//                self.twitterView.mainFrame.loadRequest(request)
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//                    let request = NSURLRequest(URL:NSURL(string:self.twitterUrl)!)
//                    self.twitterView.mainFrame.loadRequest(request)
//                }
//                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(10.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
//                    let request = NSURLRequest(URL:NSURL(string:self.twitterUrl)!)
//                    self.twitterView.mainFrame.loadRequest(request)
//                }
            })
            
            return .OK(.HTML("You asked for " + $0.url))
        }
        
        var error : NSError?;
        server.start(8080, error: &error)
        
        if let error = error {
            print("\(error)")
        }

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

