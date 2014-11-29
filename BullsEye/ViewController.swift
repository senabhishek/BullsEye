//
//  ViewController.swift
//  BullsEye
//
//  Created by Abhishek Sen on 11/28/14.
//  Copyright (c) 2014 Abhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var currentValue = 50
  var targetValue = 0
  var score = 0
  var round = 0
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var targetLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  @IBOutlet weak var roundLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    resetGame()
    let thumbImageNormal = UIImage(named: "SliderThumb-Normal")
    slider.setThumbImage(thumbImageNormal, forState: .Normal)
    
    let thumbImageHighlighted = UIImage(named: "SliderThumb-Highlighted")
    slider.setThumbImage(thumbImageHighlighted, forState: .Highlighted)
    
    let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    
    if let trackLeftImage = UIImage(named: "SliderTrackLeft") { let trackLeftResizable =
      trackLeftImage.resizableImageWithCapInsets(insets)
      slider.setMinimumTrackImage(trackLeftResizable, forState: .Normal)
    }
    
    if let trackRightImage = UIImage(named: "SliderTrackRight") {
      let trackRightResizable = trackRightImage.resizableImageWithCapInsets(insets)
      slider.setMaximumTrackImage(trackRightResizable, forState: .Normal)
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func startNewRound() {
    targetValue = 1 + Int(arc4random_uniform(100))
    currentValue = 50
    round++
    slider.value = Float(currentValue)
  }
  
  func updateLabels() {
    targetLabel.text = String(targetValue)
    scoreLabel.text = String(score)
    roundLabel.text = String(round)
  }

  @IBAction func showAlert() {
    let difference: Int = abs(currentValue - targetValue)
    var points = 100 - difference
    var title: String
    
    (points, title) = computeBonusPointsAndTitle(difference, points: points)
    score += points
    let message = "You scored \(points) points"
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,
                                handler: {
                                  action in
                                  self.startNewRound()
                                  self.updateLabels()
                                })
    alert.addAction(action)
    presentViewController(alert, animated: true, completion: nil)
  }
  
  func computeBonusPointsAndTitle(difference: Int, points: Int) -> (Int, String) {
    var title: String
    var newPoints = points
    if difference == 0 {
      title = "Perfect!"
      newPoints += 100
    } else if difference < 5 {
      title = "Almost"
      if difference == 1 {
        newPoints += 50
      }
    } else if difference < 10 {
      title = "Good try"
    } else {
      title = "Not even close ... "
    }
    
    return (newPoints, title)
  }

  @IBAction func sliderMoved(slider: UISlider) {
    currentValue = lroundf(slider.value)
  }
  
  func resetGame() {
    round = 0
    score = 0
    startNewRound()
    updateLabels()
  }
  
  @IBAction func startOver() {
    resetGame()
  }
}

