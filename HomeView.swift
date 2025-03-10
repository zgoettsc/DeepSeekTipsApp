struct HomeView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @StateObject var cycleVM = CycleViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HeaderView()
                
                ForEach(CycleItem.ItemCategory.allCases, id: \.self) { category in
                    CategorySection(category: category)
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack(alignment: .leading) {
            Text(firebaseManager.currentCycle?.patientName ?? "No Active Cycle")
                .font(.title)
            
            if let cycle = firebaseManager.currentCycle {
                Text("Cycle \(cycle.number) - Week \(currentWeek(cycle)) - Day \(currentDay(cycle))")
                    .font(.subheadline)
            }
        }
    }
    
    private func currentWeek(_ cycle: Cycle) -> Int {
        // Calculate current week based on start date
        return 1
    }
    
    private func currentDay(_ cycle: Cycle) -> Int {
        // Calculate current day based on start date
        return 1
    }
}
