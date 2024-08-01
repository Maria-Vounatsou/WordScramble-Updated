import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var scoreViewModel: ScoreViewModel
    @EnvironmentObject var viewModel: ViewModelApp
    
    @State private var showUndoAlert = false
    
    var body: some View {
        
        ZStack {
            Color("backgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            Image("Pages")
                .resizable()
                .opacity(0.7)
                .frame(width: 403, height: 880)
            
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 90)
                List {
                    ForEach(scoreViewModel.scores, id: \.id) { entry in
                        HStack {
                            Text("\(entry.date.formattedShort)")
                                .foregroundStyle(Color("buttonColor"))
                                .italic()
                        }
                        HStack {
                            Text("\(entry.word) :")
                                .bold()
                                .italic()
                            Spacer()
                            
                            Text("Total Score: \(entry.score) ")
                                .bold()
                                .italic()
                        }
                    }
                    .onDelete(perform: scoreViewModel.deleteScores)
                    .listRowBackground(Color.clear)
                }
                .background(Color.clear)
                .scrollContentBackground(.hidden)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Button("Undo Last") {
                            showUndoAlert = true
                        }
                        .padding()
                        .bold()
                        .font(.system(size: 18))
                        .frame(width: 120, height: 40)
                        .background(Color("buttonLetters"))
                        .foregroundColor(Color("scroll"))
                        .cornerRadius(15)
                        
                        .alert(isPresented: $showUndoAlert) {
                            Alert(
                                title: Text("Undo Deletion"),
                                message: Text("Would you like to undo the last deletion?"),
                                primaryButton: .default(Text("Undo"), action: {
                                    scoreViewModel.undoDelete()
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 90)
                }
            }
            .padding()
        }
        .padding()
    }
}
struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView().environmentObject(ScoreViewModel())
    }
}
