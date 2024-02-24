//
//  SwiftUIView.swift
//  
//
//  Created by yun on 2/25/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FaceDetectionViewModel()

    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .onAppear {
                    viewModel.startSession()
                }
                .onDisappear {
                    viewModel.stopSession()
                }
            ForEach(viewModel.points, id: \.self) { point in
                Circle()
                    .fill(Color.red)
                    .frame(width: 5, height: 5)
                    .position(x: point.x, y: point.y)
                    .allowsHitTesting(false)
            }
            Text(viewModel.isEyeClosed ? "눈을 감았습니다" : "눈을 떴습니다")
                .foregroundColor(.white)
                .padding()
        }
    }
}
