//
//  SwiftUIView.swift
//
//
//  Created by yun on 2/25/24.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var faceDetectVM = FaceDetectionViewModel()
  @EnvironmentObject var coreVM: CoreViewModel
  
  private let generator = UIImpactFeedbackGenerator(style: .heavy)
  
  var body: some View {
    
    VStack(spacing: 20) {
      
      if faceDetectVM.isMainOn {
        
        timeDisplay
        
        Image(faceDetectVM.isEyeClosed ? "closed" : "opened")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 240, height: 240)
          .padding()
        
        Spacer()
        
        bgmButtons
        
        Spacer()
        
      } else {
        instruction
          .padding()
        
        Spacer()
      }
    }
    .padding(.top, 30)
    .padding(.horizontal, 22)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("bgColor"))
    
    .onAppear {
      faceDetectVM.startSession()
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        faceDetectVM.mainOn()
        coreVM.startTimer()
        coreVM.playBGM()
      }
    }
    
    .onDisappear {
      faceDetectVM.stopSession()
      coreVM.stopBGM()
    }
    
    .onChange(of: faceDetectVM.isEyeClosed) { value in
      if !value && coreVM.remainingTime > 0 {
        generator.impactOccurred()
        coreVM.playSoundEffect(fileName: "warning")
      }
    }
    
    .onChange(of: coreVM.isTimeOver) { value in
      faceDetectVM.stopSession()
    }
    
    .alert("Time is over", isPresented: $coreVM.isTimeOver) {
      Button("OK", role: .cancel) {
        // dismiss
      }
    } message: {
      Text("You've experienced a great relaxation!")
    }
  }
}


extension ContentView {
  private var timeDisplay: some View {
    HStack {
      Spacer()
      Text("\(coreVM.remainingTime/60)min \(coreVM.remainingTime%60)sec")
        .font(.headline)
    }
  }
  
  private var instruction: some View {
    VStack {
      Text("Close your eyes.\n\nRelax yourself.\n\nStretch out your imagination.")
        .multilineTextAlignment(.center)
        .font(.title2.bold())
    }
    .frame(maxWidth: .infinity)
    .frame(height: 200)
    .background(.white.opacity(0.4))
    .clipShape(RoundedRectangle(cornerRadius: 30))
  }
  
  private var bgmButtons: some View {
    HStack(spacing: 100) {
      
      Button {
        coreVM.playBGM()
      } label: {
        Image(systemName: "music.quarternote.3")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 60)
          .foregroundStyle(.gray)
      }
      
      Button {
        coreVM.stopBGM()
      } label: {
        ZStack {
          Image(systemName: "music.note")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 60)
          Image(systemName: "multiply")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 70)
        }
        .foregroundStyle(.gray)
      }
    }
    .padding(.bottom, 20)
  }
}
