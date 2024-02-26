//
//  SwiftUIView.swift
//
//
//  Created by yun on 2/25/24.
//

import SwiftUI
import AVFoundation

class CoreViewModel: ObservableObject {
  
  @Published var selectedTime: Int = 0
  @Published var remainingTime: Int = 0
  @Published var isTimeOver: Bool = false
  @Published var mood: Moods = .normal
  @Published var nextStep: Bool = false
  @Published var mainStep: Bool = false
  
  private var audioPlayer: AVAudioPlayer?
  private var bgmPlayer: AVAudioPlayer?
  
  var timer: Timer? = nil
  let times: [Int] = [3, 5, 7, 10]

  func selectCounter(counter: Int) {
    self.selectedTime = counter
    mainStep = true
  }
  
  func selectMood(mood: Moods) {
    self.mood = mood
    nextStep = true
  }
  
  func startTimer() {
    self.remainingTime = self.selectedTime * 60
    self.timer?.invalidate()
    self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      if self.remainingTime > 0 {
        self.remainingTime -= 1
      } else {
        self.timer?.invalidate()
        self.timer = nil
        self.stopBGM()
        self.playSoundEffect(fileName: "done")
        self.isTimeOver = true
      }
    }
  }
  
  func playBGM() {
    if self.bgmPlayer?.isPlaying == true {
      // continue
    } else {
      if let url = Bundle.main.url(forResource: "\(self.mood.rawValue)BGM", withExtension: "mp3") {
        do {
          self.bgmPlayer = try AVAudioPlayer(contentsOf: url)
          self.bgmPlayer!.numberOfLoops = -1
          bgmPlayer!.play()
        } catch {
          print("Problem in playing warning.mp3 audio")
        }
      } else {
        print("no such file \(self.mood.rawValue)BGM")
      }
    }
  }
  
  func stopBGM() {
    if self.bgmPlayer?.isPlaying == true {
      self.bgmPlayer?.stop()
      self.bgmPlayer = nil
      print("stop")
    }
  }
  
  func playSoundEffect(fileName: String) {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
      } catch {
        print("Problem in playing warning.mp3 audio")
      }
    } else {
      print("no such file \(fileName)")
    }
  }
}
