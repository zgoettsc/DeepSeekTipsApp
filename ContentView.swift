struct ContentView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @StateObject var authVM = AuthViewModel()
    
    var body: some View {
        if authVM.isAuthenticated {
            MainTabView()
        } else {
            InitialSetupView()
        }
    }
}
