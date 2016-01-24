//
//  GameViewController.swift
//  Flappy Boognish
//
//  Created by Nicholas Dauchot on 1/15/16.
//  Copyright (c) 2016 blackhat. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {
    
    var backgroundMusicPlayer:AVAudioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
  

            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        let bgMusicURL:NSURL = NSBundle.mainBundle().URLForResource("bgMusic", withExtension: "mp3")!     // Add ! at the end
        
        backgroundMusicPlayer = try!  AVAudioPlayer(contentsOfURL: bgMusicURL)     // Add try!
        backgroundMusicPlayer.numberOfLoops = -1
        backgroundMusicPlayer.prepareToPlay()
        backgroundMusicPlayer.play()
    }
    

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
