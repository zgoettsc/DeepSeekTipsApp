import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAdmin = false
    @Published var roomCode = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        FirebaseManager.shared.$currentUser
            .map { $0 != nil }
            .assign(to: &$isAuthenticated)
        
        FirebaseManager.shared.$currentUser
            .map { $0?.isAdmin ?? false }
            .assign(to: &$isAdmin)
    }
    
    func createUser(isAdmin: Bool, roomCode: String?) {
        FirebaseManager.shared.auth.signInAnonymously { [weak self] result, error in
            guard let user = result?.user else { return }
            
            let newUser = User(
                isAdmin: isAdmin,
                roomCode: roomCode,
                settings: User.UserSettings(
                    reminders: [],
                    treatmentTimerEnabled: false
                )
            )
            
            do {
                try FirebaseManager.shared.firestore
                    .collection("users")
                    .document(user.uid)
                    .setData(from: newUser)
            } catch {
                print("Error creating user: \(error)")
            }
        }
    }
}
