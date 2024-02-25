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
  
  var timer: Timer? = nil
  let times: [Int] = [3, 5, 7, 10]
  
  
  
  func selectCounter(counter: Int) {
    self.selectedTime = counter
    print("time : \(selectedTime)")
    mainStep = true
    
  }
  
  func selectMood(mood: Moods) {
    self.mood = mood
    nextStep = true
    
  }
  
  private func playSound() {
    if let url = Bundle.main.url(forResource: "done", withExtension: "mp3") {
      do {
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
      } catch {
        print("오디오 파일을 재생하는 데 문제가 발생했습니다.")
      }
    }
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
        self.playSound()
        self.isTimeOver = true
      }
    }
  }
}
