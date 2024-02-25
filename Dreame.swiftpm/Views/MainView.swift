//
//  SwiftUIView.swift
//
//
//  Created by yun on 2/25/24.
//

import SwiftUI

struct MainView: View {
  
  @State private var selectedIndex = 0
  
  var body: some View {
    NavigationStack {
      
      VStack(spacing: 20) {
        
        TabView(selection: $selectedIndex) {
          ForEach(Quotes.allCases.indices, id: \.self) { index in
            VStack(spacing: 20) {
              Text(Quotes.allCases[index].text)
                .font(.headline)
              Text("– \(Quotes.allCases[index].author) -")
                .font(.caption)
            }
            .multilineTextAlignment(.center)
            .padding(15)
            .tag(index)
          }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(maxWidth: .infinity, maxHeight: 260)
        .background(.white.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
        HStack {
          Spacer()
          
          NavigationLink {
            MoodView()
          } label: {
            HStack {
              Text("Let's Start!")
              Image(systemName: "arrow.right.circle")
                .font(.title2)
            }
            .foregroundStyle(Color.accentColor)
          }
        }
      }
      .padding(.horizontal, 22)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .ignoresSafeArea()
      .background(Color("bgColor"))
    }
  }
}

#Preview {
  MainView()
}
