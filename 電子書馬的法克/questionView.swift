//
//  questionView.swift
//  電子書馬的法克
//
//  Created by user10 on 2024/11/5.
//

import SwiftUI

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// 問題類型
enum QuestionType {
    case trueFalse
    case multipleChoice
}

// 問題資料模型
struct Question: Identifiable {
    var id = UUID()
    var type: QuestionType
    var questionText: String
    var correctAnswer: String
    var choices: [String]? // 選擇題的選項，若為是非題則可為 nil
    var title : String
}

// 問題組別
enum QuestionGroup: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case basicRules = "初級對戰規則"
    case intermediateRules = "中級對戰規則"
    case advancedRules = "高級對戰規則"
    case typeWeakness = "屬性相剋"
    case moveDamage = "招式傷害"
}

struct questionView: View {
    @State private var selectedGroup: QuestionGroup?
        @State private var currentQuestionIndex = 0
        @State private var isFailed = false
        @State private var isSuccess = false
        @State private var usedQuestionIDs: Set<UUID> = [] // 用來記錄已出現的問題ID
        
        // 各組問題庫
        @State private var questions: [QuestionGroup: [Question]] = [
                .basicRules: [
                    Question(type: .trueFalse, questionText: "每回合只能附加一張能量卡給寶可夢，對嗎？", correctAnswer: "True", title: "初級對戰規則"),
                    Question(type: .multipleChoice, questionText: "在自己的回合可以進行以下哪個操作？", correctAnswer: "進行攻擊", choices: ["進行攻擊", "更換場上寶可夢", "棄掉所有卡牌"], title: "初級對戰規則"),
                    Question(type: .multipleChoice, questionText: "回合結束時應該在哪個階段？", correctAnswer: "攻擊結束", choices: ["能量附加", "道具使用", "攻擊結束"], title: "初級對戰規則"),
                    Question(type: .trueFalse, questionText: "進攻階段時可以放置能量卡，對嗎？", correctAnswer: "False", title: "初級對戰規則"),
                    Question(type: .multipleChoice, questionText: "寶可夢的HP代表什麼？", correctAnswer: "生命值", choices: ["生命值", "攻擊力", "防禦力"], title: "初級對戰規則"),
                    Question(type: .multipleChoice, questionText: "當對手寶可夢被擊倒，您可以抽取多少張獎勵卡？", correctAnswer: "1張", choices: ["1張", "2張", "3張"], title: "初級對戰規則")
                ],
                
                .intermediateRules: [
                    Question(type: .trueFalse, questionText: "寶可夢可以進行連續攻擊，對嗎？", correctAnswer: "False", title: "中級對戰規則"),
                    Question(type: .multipleChoice, questionText: "對手的寶可夢被擊倒時，您可以：", correctAnswer: "抽取一張獎勵卡", choices: ["抽取一張獎勵卡", "立即進行下一回合", "重新開始遊戲"], title: "中級對戰規則"),
                    Question(type: .multipleChoice, questionText: "當您的寶可夢被擊倒，您應該：", correctAnswer: "換另一隻寶可夢", choices: ["換另一隻寶可夢", "直接結束遊戲", "放置能量卡"], title: "中級對戰規則"),
                    Question(type: .trueFalse, questionText: "您可以在同一回合中使用多個道具，對嗎？", correctAnswer: "True", title: "中級對戰規則"),
                    Question(type: .multipleChoice, questionText: "能量卡的數量對寶可夢的什麼屬性有影響？", correctAnswer: "攻擊力", choices: ["生命值", "攻擊力", "防禦力"], title: "中級對戰規則")
                ],
                
                .advancedRules: [
                    Question(type: .trueFalse, questionText: "進行進化後的寶可夢可以立即攻擊，對嗎？", correctAnswer: "False", title: "高級對戰規則"),
                    Question(type: .multipleChoice, questionText: "當寶可夢進化時，會發生什麼事？", correctAnswer: "重置所有狀態效果", choices: ["重置所有狀態效果", "獲得額外一回合", "提升攻擊力"], title: "高級對戰規則"),
                    Question(type: .multipleChoice, questionText: "進化寶可夢需要什麼條件？", correctAnswer: "對應的進化卡", choices: ["對應的進化卡", "任意能量卡", "道具卡"], title: "高級對戰規則"),
                    Question(type: .multipleChoice, questionText: "寶可夢可以進化幾次？", correctAnswer: "不限次數", choices: ["一次", "兩次", "不限次數"], title: "高級對戰規則"),
                    Question(type: .trueFalse, questionText: "使用技能後，寶可夢不能攻擊，對嗎？", correctAnswer: "True", title: "高級對戰規則")
                ],
                
                .typeWeakness: [
                    Question(type: .multipleChoice, questionText: "水屬性寶可夢對哪一種屬性有加倍傷害？", correctAnswer: "火屬性", choices: ["火屬性", "電屬性", "草屬性"], title: "屬性相剋"),
                    Question(type: .multipleChoice, questionText: "火屬性寶可夢對以下哪個屬性有加倍傷害？", correctAnswer: "草屬性", choices: ["水屬性", "草屬性", "飛行屬性"], title: "屬性相剋"),
                    Question(type: .trueFalse, questionText: "電屬性寶可夢對水屬性寶可夢有加倍傷害，對嗎？", correctAnswer: "True", title: "屬性相剋"),
                    Question(type: .multipleChoice, questionText: "草屬性寶可夢最怕什麼屬性？", correctAnswer: "火屬性", choices: ["火屬性", "水屬性", "地面屬性"], title: "屬性相剋"),
                    Question(type: .trueFalse, questionText: "水屬性寶可夢對地面屬性寶可夢有加倍傷害，對嗎？", correctAnswer: "True", title: "屬性相剋"),
                    Question(type: .multipleChoice, questionText: "哪種屬性對飛行屬性有加倍傷害？", correctAnswer: "電屬性", choices: ["水屬性", "電屬性", "火屬性"], title: "屬性相剋")
                ],
                
                .moveDamage: [
                    Question(type: .multipleChoice, questionText: "藤鞭的傷害是多少？", correctAnswer: "50", choices: ["30", "50", "70"], title: "屬性相剋"),
                    Question(type: .multipleChoice, questionText: "火焰拳的傷害是多少？", correctAnswer: "60", choices: ["40", "60", "80"], title: "屬性相剋"),
                    Question(type: .trueFalse, questionText: "電擊的傷害比火焰拳少，對嗎？", correctAnswer: "True", title: "屬性相剋"),
                    Question(type: .multipleChoice, questionText: "水炮的傷害是多少？", correctAnswer: "70", choices: ["50", "70", "90"], title: "屬性相剋"),
                    Question(type: .trueFalse, questionText: "破壞光線的傷害超過100，對嗎？", correctAnswer: "True", title: "屬性相剋"),
                    Question(type: .multipleChoice, questionText: "火焰車的傷害是多少？", correctAnswer: "90", choices: ["60", "80", "90"], title: "屬性相剋"),
                    Question(type: .trueFalse, questionText: "泰山壓頂的傷害低於30，對嗎？", correctAnswer: "False", title: "屬性相剋")
                ]
            ]
                
        
    
        @State private var currentQuestions: [Question] = []
        @State private var showAnimation = false // 控制動畫效果
        @State private var isVisible = true // 控制框框是否隱形
        
        var body: some View {
            ZStack{
                    Image(.questionBack).resizable().scaledToFill().opacity(0.6).ignoresSafeArea()
            ScrollView {
                
                VStack {
                    // Instagram 限動風格的按鈕
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(QuestionGroup.allCases) { group in
                                Button(action: {
                                    selectGroup(group)
                                }) {
                                    VStack {
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 100, height: 70)
                                            .overlay(Image(String(group.rawValue.prefix(2))).resizable().scaledToFit())
                                        Capsule()
                                            .frame(height: 25.0)
                                            .foregroundStyle(Color.white.opacity(0.8))
                                            .overlay(
                                                Text(group.rawValue)
                                                    .font(.custom("Cubic_11", size: 13))
                                                    .foregroundColor(.black)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                                
                    Spacer().frame(height: 20)
                    
                    // 問題顯示區域
                    if let question = currentQuestions[safe: currentQuestionIndex] {
                        VStack(spacing: 30) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: 2)
                                    .frame(width: 260.0, height: 55)
                                
                                // 內部顏色
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .frame(width: 255.0, height: 50)
                                Text(question.title)
                                    .cornerRadius(10)
                                    .foregroundColor(.black)
                                    .opacity(isVisible ? 1 : 0) // 設定條件隱形
                                    .animation(.easeInOut(duration: 0.5), value: isVisible) // 可選動畫效果
                            }
                            Image(.黑板)
                                .resizable()
                                .scaledToFit()
                                .overlay(Text(question.questionText)
                                    .font(.custom("HanyiSentyCrayon", size: 30))
                                    .foregroundStyle(Color.white)
                                    .padding()
                                )
                            if question.type == .trueFalse {
                                HStack(spacing: 40) {
                                    Button(action: { checkAnswer("True") }) {
                                        ZStack{
                                            Circle()
                                                .frame(width: 120, height: 120)
                                                .foregroundStyle(Color.white)
                                                .opacity(0.7)
                                            Image("true_icon") // 替換成你的 True 圖片資源名稱
                                                .resizable()
                                                .frame(width: 75, height: 75)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Button(action: { checkAnswer("False") }) {
                                        ZStack{
                                            Circle()
                                                .frame(width: 120, height: 120)
                                                .foregroundStyle(Color.white)
                                                .opacity(0.7)
                                            Image("false_icon")
                                                .resizable()
                                                .frame(width: 75, height: 75)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            } else if let choices = question.choices {
                                VStack(spacing: 10) {
                                    ForEach(choices, id: \.self) { choice in
                                        Button(action: { checkAnswer(choice) }) {
                                            ZStack {
                                                // 外框
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.black, lineWidth: 2)
                                                    .frame(width: 160.0, height: 55)
                                                
                                                // 內部顏色
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .frame(width: 155.0, height: 50)
                                                
                                                // 選項文字
                                                Text(choice)
                                                    .foregroundColor(.black)
                                                    .padding(.horizontal)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    else{
                        Image(.黑板)
                            .resizable()
                            .scaledToFit()
                            .overlay(Text("Poke問答")
                                .font(.custom("HanyiSentyCrayon", size: 90))
                                .foregroundStyle(Color.white)
                                .padding()
                            )
                            .padding()
                    }
                    
                    Spacer().frame(height: 20)
                    
                    // 失敗或成功的圖片動畫
                    HStack(spacing: 30) {
                        Image("成功圖片")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .scaleEffect(isSuccess && showAnimation ? 5.0 : 1.0)
                            .offset(x: isSuccess && showAnimation ? 200: 0,y: isSuccess && showAnimation ? -300: 0)
                            .animation(.easeInOut(duration: 0.5), value: showAnimation)
                            .onChange(of: isSuccess) { newValue in
                                if newValue {
                                    triggerAnimation()
                                }
                            }
                        
                        Image("失敗圖片")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .scaleEffect(isFailed && showAnimation ? 5.0 : 1.0)
                            .offset(x: isFailed && showAnimation ? -100: 0,y: isFailed && showAnimation ? -300: 0)
                            .animation(.easeInOut(duration: 0.5), value: showAnimation)
                            .onChange(of: isFailed) { newValue in
                                if newValue {
                                    triggerAnimation()
                                }
                            }
                    }
                }
                    .padding(.vertical)
                    .animation(.easeInOut, value: isFailed || isSuccess)
                }
            }
        }
    
        private func triggerAnimation() {
            showAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showAnimation = false
                if isFailed {
                    resetQuiz()
                } else if isSuccess {
                    // 顯示成功後進入下一題
                    isSuccess = false
                    currentQuestionIndex += 1
                }
            }
        }
        // 選擇問題組別並亂數選題，不重複已出現的問題
        private func selectGroup(_ group: QuestionGroup) {
            selectedGroup = group
            currentQuestionIndex = 0
            isFailed = false
            isSuccess = false
            
            // 設定問題數量
            let questionCount = group == .basicRules || group == .intermediateRules || group == .advancedRules ? 3 : 5
            let allQuestions = questions[group] ?? []
            
            // 過濾掉已出現的問題，並隨機選取題數
            let availableQuestions = allQuestions.filter { !usedQuestionIDs.contains($0.id) }
            currentQuestions = Array(availableQuestions.shuffled().prefix(questionCount))
            
            // 記錄新選擇的問題ID
            usedQuestionIDs.formUnion(currentQuestions.map { $0.id })
        }
        
        // 驗證答案
        private func checkAnswer(_ answer: String) {
            guard let question = currentQuestions[safe: currentQuestionIndex] else { return }
            
            if answer == question.correctAnswer {
                if currentQuestionIndex == currentQuestions.count - 1 {
                    isSuccess = true // 全部答對
                } else {
                    currentQuestionIndex += 1 // 進入下一題
                }
            } else {
                isFailed = true // 答錯
            }
        }
        
        // 重置答題流程
        private func resetQuiz() {
            isFailed = false
            isSuccess = false
            currentQuestionIndex = 0
            currentQuestions.removeAll()
            usedQuestionIDs.removeAll() // 清除已出現的問題ID
            selectedGroup = nil
        }
}

#Preview {
    questionView()
}
