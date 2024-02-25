//
//  SwiftUIView.swift
//
//
//  Created by yun on 2/25/24.
//

import SwiftUI

struct MoodView: View {
  @StateObject var coreVM = CoreViewModel()
  
  var body: some View {
    VStack(spacing: 20) {
      headTitle
      
      moodOptions
    }
    .padding(.horizontal, 22)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color("bgColor"))
    .navigationDestination(isPresented: $coreVM.nextStep, 
                           destination: { CounterView().environmentObject(coreVM) })
  }
}

extension MoodView {
  private var headTitle: some View {
    HStack {
      Text("Today's Mood")
        .font(.title.bold())
        .padding()
      Spacer()
    }
  }
  
  private var moodOptions: some View {
    ForEach(Moods.allCases, id: \.self) { mood in
      Button(action: {
        coreVM.selectMood(mood: mood)
      }) {
        
        HStack {
          Image(mood.rawValue)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .padding(.horizontal, 30)
          Text("\(mood.text)")
            .foregroundColor(.black)
            .font(.headline.bold())
          Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color.white.opacity(0.4))
        .cornerRadius(30)
      }
    }
  }
}


#Preview {
  MoodView()
}
