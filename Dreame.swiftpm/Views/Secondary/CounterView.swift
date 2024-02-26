//
//  SwiftUIView.swift
//
//
//  Created by yun on 2/25/24.
//

import SwiftUI

struct CounterView: View {
  @EnvironmentObject var coreVM: CoreViewModel
  
  var body: some View {
    VStack(spacing: 20) {
      
      headTitle
      
      options
    }
    .padding(.horizontal, 22)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("bgColor"))
    .navigationDestination(isPresented: $coreVM.mainStep, 
                           destination: { ContentView().environmentObject(coreVM) })
  }
}

extension CounterView {
  private var headTitle: some View {
    HStack {
      Text("Select Timer")
        .font(.title.bold())
        .padding()
      Spacer()
    }
  }
  
  private var options: some View {
    ForEach(0..<4) { index in
      Button(action: {
        coreVM.selectCounter(counter: coreVM.times[index])
      }) {
        Text("\(coreVM.times[index]) min")
          .foregroundColor(.black)
          .font(.headline)
          .frame(maxWidth: .infinity)
          .frame(height: 110)
          .background(Color.white.opacity(0.4))
          .cornerRadius(30)
      }
    }
  }
}

#Preview {
  CounterView()
}
