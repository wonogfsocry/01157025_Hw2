//
//  InfoRow.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/5.
//

import SwiftUI

struct InfoRow: View {
    let info : String
    let pic1 : ImageResource
    let pic2 : ImageResource
    let pic3 : ImageResource
    var body: some View {
        VStack{
            HStack {
                Image(pic1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75.0, height: 75.0)
                Spacer()
                Text(info)
                    .multilineTextAlignment(.center)
                    .font(.custom("PokemonSolidNormal", size: 35))
                Spacer()
                Image(pic1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75.0, height: 75.0)
            }
            Image(pic2)
                .resizable()
                .scaledToFit()
        }
        .background(Image(pic3).resizable().scaledToFill())
    }
}
