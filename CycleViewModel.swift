import Combine

class CycleViewModel: ObservableObject {
    @Published var currentCycle: Cycle?
    @Published var items: [CycleItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        FirebaseManager.shared.$currentCycle
            .sink { [weak self] cycle in
                self?.currentCycle = cycle
                self?.items = cycle?.items ?? []
            }
            .store(in: &cancellables)
    }
    
    func toggleItemCompletion(_ item: CycleItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        
        items[index].isCompleted.toggle()
        updateCycleItems()
    }
    
    private func updateCycleItems() {
        guard let cycle = currentCycle,
              let uid = FirebaseManager.shared.currentUser?.id else { return }
        
        do {
            try FirebaseManager.shared.firestore
                .collection("users")
                .document(uid)
                .collection("cycles")
                .document(cycle.id ?? "")
                .setData(from: cycle)
        } catch {
            print("Error updating cycle: \(error)")
        }
    }
}
