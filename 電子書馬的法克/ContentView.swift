//
//  ContentView.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/4.
//

import SwiftUI

struct ContentView: View {
    @State private var isSpringExpanded = false
    @State private var showHintText = true
    @State private var NextPage = false
    var body: some View {
        if !NextPage {
            VStack {
                ZStack{
                    Text("Pokemon TCG")
                        .font(.custom("PokemonSolidNormal", size: 50))
                        .foregroundStyle(.yellow)
                        .bold()
                        .padding()
                }
                // 寶可夢照片，持續彈簧跳動效果
                Image(.mainpikachu) // 使用您的寶可夢圖片名稱
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
                    .scaleEffect(isSpringExpanded ? 1.5 : 1)
                    .onAppear {
                        // 持續的彈簧動畫
                        withAnimation(
                            Animation
                                .spring(response: 0.5, dampingFraction: 0.3, blendDuration: 1)
                                .repeatForever(autoreverses: true)
                        ) {
                            isSpringExpanded.toggle()
                        }
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            showHintText.toggle()
                        }
                    }
                    .padding(.top, 75)
                    .padding(.bottom, 120)
                if showHintText {
                    Text("觸碰螢幕來啟動")
                        .font(.custom("HanyiSentyCrayon", size: 30))
                        .foregroundStyle(.yellow)
                        .transition(.opacity) // 若隱若現動畫
                }
            }
            .frame(width: 500.0, height: 850.0)
            .background(Image(.defaultback).resizable().scaledToFill().ignoresSafeArea())
            .ignoresSafeArea()
            .onTapGesture {
                // 點擊螢幕任何地方跳轉到下一頁
                NextPage = true
            }
        }
        else if NextPage{
            NavigationStack{
                TabView {
                    Tab("圖鑑", systemImage: "book.closed.fill") {
                        BookView()
                    }
                    Tab("問答", systemImage: "questionmark.bubble"){
                        questionView()
                    }
                    Tab("介紹", systemImage: "info.bubble.fill.rtl"){
                        introduceView()
                    }
                }
                .tabViewStyle(.sidebarAdaptable)
            }
        }
    }
}
#Preview {
    ContentView()
}
