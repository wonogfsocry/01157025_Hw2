//
//  timer.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/20.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerviewModel: TimerViewModel
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            formatTime(timerviewModel.timerValue)
            .font(.system(size: 30, weight: .bold, design: .monospaced))
            .foregroundColor(Color.white)
            .padding()
        }
    }
    
    private func formatTime(_ seconds: Int) -> Text {
        let minutes = seconds / 60
        let seconds = seconds % 60
        if minutes == 0 && seconds <= 10{
            audioManager.playSoundEffect(named: "warning")
            return Text(String(format: "%02d:%02d", minutes, seconds)).foregroundColor(.red) // 設定文字為紅色
        }
        else{
            return Text(String(format: "%02d:%02d", minutes, seconds))
        }
    }
}

class TimerViewModel: ObservableObject {
    @Published var timerValue: Int = 60
    @Published var isRunning: Bool = false
    var timer: Timer?
    
    enum TimerMode {
        case countdown
        case stopwatch
    }
    
    var timerMode: TimerMode = .countdown
    
    func startTimer() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            DispatchQueue.main.async {
                switch self.timerMode {
                case .countdown:
                    if self.timerValue > 0 {
                        self.timerValue -= 1
                    } else {
                        self.stopTimer()
                    }
                case .stopwatch:
                    self.timerValue += 1
                }
            }
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func resetTimer() {
        pauseTimer()
        timerValue = timerMode == .countdown ? 60 : 0
    }
    
    func stopTimer() {
        isRunning = false
        timer?.invalidate()
    }
}

