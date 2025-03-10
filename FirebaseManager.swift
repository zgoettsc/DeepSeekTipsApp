import Firebase
import Combine

class FirebaseManager: NSObject, ObservableObject {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let firestore: Firestore
    
    @Published var currentUser: User?
    @Published var currentCycle: Cycle?
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        super.init()
        
        setupAuthListener()
    }
    
    private func setupAuthListener() {
        auth.addStateDidChangeListener { [weak self] (_, user) in
            if let user = user {
                self?.fetchUserData(uid: user.uid)
                self?.fetchCurrentCycle(uid: user.uid)
            }
        }
    }
    
    private func fetchUserData(uid: String) {
        firestore.collection("users").document(uid)
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let data = snapshot?.data() else { return }
                self?.currentUser = try? snapshot?.data(as: User.self)
            }
    }
    
    private func fetchCurrentCycle(uid: String) {
        firestore.collection("users").document(uid).collection("cycles")
            .whereField("challengeDate", isGreaterThan: Date())
            .addSnapshotListener { [weak self] snapshot, _ in
                guard let document = snapshot?.documents.first else { return }
                self?.currentCycle = try? document.data(as: Cycle.self)
            }
    }
}
