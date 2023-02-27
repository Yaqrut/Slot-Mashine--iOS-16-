//
//  ContentView.swift
//  Slot Mashine
//
//  Created by YAQRUT on 2023-02-22.
//

import SwiftUI

struct ContentView: View {
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmout: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActivateBet10: Bool = true
    @State private var isActivateBet20: Bool = false
    @State private var shovingModal: Bool = false
    @State private var animationSymbol: Bool = false
    @State private var animationModal: Bool = false
    
    
    //FUNC
    
    //SPIN THE REELS
    func spinReels() {
        //reels[0] = Int.random(in: 0...symbols.count - 1)
        //reels[1] = Int.random(in: 0...symbols.count - 1)
        //reels[2] = Int.random(in: 0...symbols.count - 1)
        
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    //CHECK THE WINNING
    func checkTheWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            //PLAYER WIN
            playerWin()
            
            //NEW HIGH SCORE
            if coins > highScore {
                newHighScore()
            }
        } else {
            //PLAYER LOSES
            playerLoses()
        }
    
    
    func playerWin(){
        coins += betAmout * 10
        playSound(sound: "win", type: "mp3")
    }
        
    func newHighScore() {
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }
        
    func playerLoses() {
        coins -= betAmout
    }
        
    }
    
    func activateBet20() {
        betAmout = 20
        isActivateBet20 = true
        isActivateBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activateBet10() {
        betAmout = 10
        isActivateBet10 = true
        isActivateBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    //GAME OVER
    func isGameOver() {
        if coins <= 0 {
            shovingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 5) {
                    
                    //HEADER
                    LogoView()
                    Spacer()
                    
                    //SCORE
                    
                    HStack {
                        HStack {
                            Text("Your\nCoins".uppercased())
                                .scoreLabelStyle()
                                .multilineTextAlignment(.trailing)
                            
                            Text("\(coins)")
                                .scoreNumberStyle()
                                .modifier(scoreNumberModifier())
                            
                            
                        }
                        .modifier(scoreContainerModifier())
                        
                        Spacer()
                        
                        HStack {
                            Text("\(highScore)")
                                .scoreNumberStyle()
                                .modifier(scoreNumberModifier())
                            
                            Text("High\nScore".uppercased())
                                .scoreLabelStyle()
                                .multilineTextAlignment(.leading)
                            
                            
                        }
                        .modifier(scoreContainerModifier())
                    }
                    //SLOT MASHINE
                    
                    VStack(alignment: .center, spacing: 0) {
                        //REAL #1
                        ZStack {
                            RealView()
                            Image(symbols[reels[0]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animationSymbol ? 1 : 0)
                                .offset(y: animationSymbol ? 0 : -50)
                                .onAppear(perform: {
                                    self.animationSymbol.toggle()
                                    playSound(sound: "riseup", type: "mp3")
                                })
                        }
                        HStack(alignment: .center, spacing: 0) {
                            //REAL #2
                            ZStack {
                                RealView()
                                Image(symbols[reels[1]])
                                    .resizable()
                                    .modifier(ImageModifier())
                                    .opacity(animationSymbol ? 1 : 0)
                                    .offset(y: animationSymbol ? 0 : -50)
                                    .onAppear(perform: {
                                        self.animationSymbol.toggle()
                                        playSound(sound: "riseup", type: "mp3")
                                    })
                            }
                            Spacer()
                            
                            //REAL #3
                            ZStack {
                                RealView()
                                Image(symbols[reels[2]])
                                    .resizable()
                                    .modifier(ImageModifier())
                                    .opacity(animationSymbol ? 1 : 0)
                                    .offset(y: animationSymbol ? 0 : -50)
                                    .onAppear(perform: {
                                        self.animationSymbol.toggle()
                                        playSound(sound: "riseup", type: "mp3")
                                    })
                            }
                        }
                        //SPIN BUTTON
                        Button(action: {
                            //SET THE DEFAULT STATE: NO ANIMATION
                            withAnimation {
                                self.animationSymbol = false
                            }
                            //SPIN THE REELS WITH CHANGING THE SYMBOLS
                            self.spinReels()
                            
                            //TRIGGER THE ANIMATION AFTER CHANGING THE SYMBOLS
                            withAnimation {
                                self.animationSymbol = true
                            }
                            
                            
                            //CHECK WINNING
                            self.checkTheWinning()
                            
                            self.isGameOver()
                        }) {
                            Image("gfx-spin")
                                .renderingMode(.original)
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }
                    .layoutPriority(2)
                    //FOOTER
                    
                    Spacer()
                    
                    HStack {
                        //BET 20
                        HStack(alignment: .center, spacing: 10) {
                            Button(action: {
                                activateBet20()
                            }) {
                                Text("20")
                                    .fontWeight(.heavy)
                                    .foregroundColor(isActivateBet20 ? Color("ColorYellow") : Color.white)
                                    .modifier(BetNumberModifier())
                            }
                            .modifier(BetCupsModifier())
                            
                            Image("gfx-casino-chips")
                                .resizable()
                                .offset(x: isActivateBet20 ? 0 : 20)
                                .opacity(isActivateBet20 ? 1 : 0)
                                .modifier(CasinoChipsModifier())
                            
                        }
                        Spacer()
                        //BET 10
                        HStack(alignment: .center, spacing: 10) {
                            Image("gfx-casino-chips")
                                .resizable()
                                .offset(x: isActivateBet10 ? 0 : -20)
                                .opacity(isActivateBet10 ? 1 : 0)
                                .modifier(CasinoChipsModifier())
                            
                            Button(action: {
                                self.activateBet10()
                            }) {
                                Text("10")
                                    .fontWeight(.heavy)
                                    .foregroundColor(isActivateBet10 ? Color("ColorYellow") : Color.white)
                                    .modifier(BetNumberModifier())
                            }
                            .modifier(BetCupsModifier())
                            
                        }
                    }
                }
                //BUTTONS
                .overlay(
                    //RESET
                    Button(action: {
                        self.resetGame()
                    }) {
                        Image(systemName: "arrow.2.circlepath.circle")
                    }
                        .modifier(ButtonModifier()),
                    alignment: .topLeading
                )
                
                .overlay(
                    //INFO
                    Button(action: {
                        self.showingInfoView = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                        .modifier(ButtonModifier()),
                    alignment: .topTrailing
                )
                
                
                .padding()
                .frame(maxWidth: 720)
                .blur(radius: $shovingModal.wrappedValue ? 5 : 0, opaque: false)
               
            //POP UP
            
            if $shovingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                    
                    VStack(spacing: 0) {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color .white)
                        
                        Spacer()
                        
                        //MESSAGE
                        
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-casino-chips")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck!You lost all coins!\n Let's try again")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.shovingModal = false
                                self.animationModal = false
                                self.activateBet10()
                                self.coins = 100
                            }) {
                                Text("NEW GAME")
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                    Capsule()
                                        .strokeBorder(lineWidth: 1.75))
                            }
                        }
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.yellow)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animationModal.wrappedValue ? 1 : 0)
                    .offset(y: $animationModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0), value: 1.0)
                    .onAppear {
                        self.animationModal = true
                    }
                    
                }
            }
                
        }
            .sheet(isPresented: $showingInfoView) {
                InfoView()
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }


