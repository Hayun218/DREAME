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
    
    VStack {
      
      if faceDetectVM.isMainOn {
        
        // 남은 타이머
        HStack {
          Spacer()
          Text("\(coreVM.remainingTime/60)분 \(coreVM.remainingTime%60)초")
            .font(.headline)
        }
        
        // 카메라뷰 => 이미지 에셋으로 수정 눈 감은 버전, 눈 뜬 버전,,
        //        CameraPreview(session: faceDetectVM.session)
        //          .frame(maxWidth: .infinity)
        //          .frame(height: 160)
        
        Image(faceDetectVM.isEyeClosed ? "closed" : "opened")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 300, height: 300)
        
        Spacer()
        
      } else {
        VStack {
          Text("Close your eyes.\n\nRelax yourself.\nThen, stretch out your imagination.")
            .multilineTextAlignment(.center)
            .font(.title2.bold())
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(.white.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 30))
      }
    }
    .padding(.horizontal, 22)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("bgColor"))
    
    .onAppear {
      faceDetectVM.startSession()
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        faceDetectVM.mainOn()
        coreVM.startTimer()
      }
    }
    .onDisappear {
      faceDetectVM.stopSession()
    }
    .onChange(of: faceDetectVM.isEyeClosed) { value in
      if !value && coreVM.remainingTime > 0 {
        generator.impactOccurred()
      }
    }
    .onChange(of: coreVM.isTimeOver) { value in
      faceDetectVM.stopSession()
    }
    
    .alert("Completed", isPresented: $coreVM.isTimeOver) {
      let _ = print("completed")
    } message: {
      Text("dd")
    }
    
  }
}
