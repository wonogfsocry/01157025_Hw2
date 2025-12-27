//
//  introduce.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/8.
//
import SwiftUI
import AVKit

struct introduceView: View {
    let pokemonImages = ["image1", "image2", "image3"]
    let videoURL = Bundle.main.url(forResource: "introvedio", withExtension: "mp4") //影片檔案名稱和類型

    var body: some View {
        ScrollView{
            VStack(spacing: 20) {
                Text("Introduce")
                    .padding(-10)
                    .font(.custom("PokemonSolidNormal", size: 30))
                    .bold()
                // 上方圖片
                Link(destination: URL(string: "https://www.pokemontcgpocket.com/tc/about/")!, label: {
                    ZStack{
                        Image(.木框)
                            .resizable()
                            .frame(width: 375, height: 211.5)
                            .scaledToFit()
                        Image("pokemonTCGLogo") // 寶可夢 TCG 相關圖片名稱
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350, height: 200)
                            .scaledToFit()
                            .cornerRadius(15)
                            .padding()
                    }
                })
                // 介紹文字
                Text("Pokemon TCG 是一個卡片對戰遊戲，玩家可以使用不同的寶可夢卡牌來組建自己的卡組並進行對戰。")
                    .font(.custom("HanyiSentyCrayon", size: 23))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                Text("How To Play")
                    .padding(.bottom, -100)
                    .font(.custom("PokemonSolidNormal", size: 30))
                    .bold()
                // 分頁瀏覽
                TabView {
                    ForEach(pokemonImages, id: \.self) {
                        imageName in
                        ZStack{
                            Image(.木框)
                                .resizable()
                                .frame(width: 380, height: 259)
                                .scaledToFit()
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 365, height:235)
                                .scaledToFit()
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 350)
                Text("Video")
                    .padding(.bottom, -10.0)
                    .font(.custom("PokemonSolidNormal", size: 30))
                    .bold()
                // 播放影片
                ZStack{
                    Image(.木框)
                        .resizable()
                        .frame(width: 370, height: 212.5)
                        .scaledToFit()
                    if let url = videoURL {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(width:343.5, height: 193)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("無法載入影片")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
        }
        .background(Image(.pokeball).resizable().scaledToFill().opacity(0.3).blur(radius:5).ignoresSafeArea())
    }
    
}
#Preview {
    introduceView()
}
