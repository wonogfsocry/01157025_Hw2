//
//  music.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/21.
//

import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?
    
    // 播放背景音樂
    func playBackgroundMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("找不到背景音樂檔案")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // 無限循環
            backgroundMusicPlayer?.play()
        } catch {
            print("背景音樂播放錯誤: \(error)")
        }
    }
    
    // 停止背景音樂
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    // 播放音效
    func playSoundEffect(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("找不到音效檔案")
            return
        }
        
        do {
            soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
            soundEffectPlayer?.play()
        } catch {
            print("音效播放錯誤: \(error)")
        }
    }
}
