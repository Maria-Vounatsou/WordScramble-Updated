
//  ContentView.swift
//  WordScramble
//
//  Created by Maria Vounatsou on 10/5/24.



import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var viewModel = ViewModelApp()
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("books")
                    .resizable()
                    .opacity(0.3)
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        Section {
                            TextField("Enter your word", text: $viewModel.newWord)
                                .textInputAutocapitalization(.never)
                                .listRowBackground(Color("ColorV"))
                        }
                        Section {
                            ForEach(viewModel.usedWords, id: \.self) { word in
                                HStack {
                                    Image(systemName: "\(word.count).circle")
                                    Text(word)
                                }
                                .listRowBackground(Color("ColorV"))
                            }
                        }
                    }
                    .navigationTitle(viewModel.rootWord)
                    .onSubmit(viewModel.addNewWord)
                    .onAppear(perform: viewModel.initializeIfNeeded )
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    
                    Text("SCORE\n      \(viewModel.score)")
                        .padding(10)
                        .fontWeight(.heavy)
                        .font(.system(size: 17))
                        .frame(width: 180, height: 80)
                        .background(Color("ColorV"))
                        .foregroundColor(Color("scroll"))
                        .cornerRadius(15)
                    
                    NavigationLink(destination: ScoreView()) {
                        Text("Save")
                            .padding()
                            .bold()
                            .font(.system(size: 23))
                            .frame(width: 200, height: 40)
                            .background(Color("buttonColor"))
                            .foregroundColor(Color("scroll"))
                            .cornerRadius(15)
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        if let currentWord = viewModel.currentWord {
                            scoreViewModel.addScore( newScore: viewModel.score, word: currentWord)
                        }
                        viewModel.startGame()
                        viewModel.startOver()
                    })
                }
                .padding(.bottom, 40)
                
                // Automatic Button: alert(errorTitle, isPresented: $showingError) {} message: {Text(errorMessage)}
                .alert(viewModel.errorTitle, isPresented: $viewModel.showingError) {
                    Button("OK") {}
                } message: {
                    Text(viewModel.errorMessage)
                }
                .toolbar {
                    ToolbarItemGroup {
                        HStack {
                            NavigationLink(destination: ScoreView().environmentObject(viewModel)) {
                                Text("SCORE")
                            }
                            Spacer()
                                .frame(width: 260)
                            
                            Button(action: {
                                viewModel.startGame()
                                viewModel.startOver()
                            }) {
                                Label("Start Over", systemImage: "arrow.clockwise")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ViewModelApp()
        let scoreViewModel = ScoreViewModel() 
        ContentView()
            .environmentObject(viewModel)
            .environmentObject(scoreViewModel)
    }
}

