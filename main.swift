import Foundation

//async/await

func fetchPhotoNames(from gallery:String) async throws ->[String]{
    print(" fetchPhotoNames starting network call for gallery ")
    try await Task.sleep(for: .seconds(2))
    print("fetchPhotoNames call completed , returning names")
    return ["sunset.jpg","mountain.jpg","lake.jpg"]
}

func downloadPhoto(named name: String) async throws -> String{
    
    print("downloading: \(name)")
    try await Task.sleep(for : .seconds(2))
    print("done downloading")
    return "image_\(name)"
}

func showPhoto(_ data: String){
    print("[showPhoto] Displaying : \(data)")
}

let task = Task {
    print("async / await demo \n")
    print("1. Fetching photo names from gallery")
    let names = try await fetchPhotoNames(from: "SummerVacation")
    print("got names")
    let sortedNames = names.sorted()
    let firstName = sortedNames[0]
    print("downloading the photo : \(firstName)")
    let photo =  try await downloadPhoto(named: firstName)
    print("showing the photo")
    showPhoto(photo)
    print("total photos available : \(names.count)")
}

Thread.sleep(forTimeInterval: 5)

//async sequences

func stream() -> AsyncStream<Int> {
    AsyncStream { continuation in
        Task {
            for i in 1...3 {
                try? await Task.sleep(for: .seconds(1))
                continuation.yield(i)
            }
            continuation.finish()
        }
    }
}
Task {
    for await value in stream() {
        print("Got:", value)
    }
}

Thread.sleep(forTimeInterval: 7)

//sequential vs parallel

func download(photo name:String, delay:Double) async throws -> String{
    print("started: \(name)")
    try await Task.sleep(for: .seconds(delay))
    print("finished: \(name) (took \(delay) seconds)")
    return "DATA: \(name)"
}
let task1 = Task{
    print("sequential")
    var start  = Date()
    let p1 = try await download(photo: "a", delay: 1)
    let p2 = try await download(photo: "b", delay: 3)
    let p3 = try await download(photo: "c", delay: 2)
    let end = Date().timeIntervalSince(start)
    print("sequential total: \(String(format: "%.1f",end))s")
    let _ = [p1,p2,p3]
    print("parallel")
    start = Date()
    async let q1 = download(photo: "a", delay: 1)
    async let q2 = download(photo: "b", delay: 3)
    async let q3 = download(photo: "c", delay: 2)
    let _ = try await [q1,q2,q3]
    let end2 = Date().timeIntervalSince(start)
    print("parallel total : \(String(format: "%.1f",end2))s")
    
}

Thread.sleep(forTimeInterval: 10)

//actor

actor SafeCounter {
    var value = 0
    func increment() {
        value += 1
        print("incremented to", value)
    }
    
    func getValue() -> Int {
        return value
    }
}

let actorTask = Task {
    print("Actor demo")
    let counter = SafeCounter()
    async let t1:Any = counter.increment()
    async let t2:Any = counter.increment()
    async let t3:Any = counter.increment()
    _ = await [t1, t2, t3]
    let final = await counter.getValue()
    print("Final value:", final)
}

Thread.sleep(forTimeInterval: 3)

//main actor

@MainActor
func updateUI(_ message: String) {
    print("UI updated with message:", message)
}

func fetchData() async -> String {
    try? await Task.sleep(for: .seconds(2))
    return "Data loaded from server"
}

Task {
    print("App started")
    let result = await fetchData()
    await updateUI(result)
    print("Done")
}

RunLoop.main.run()

//isolation

actor BankAccount {
    var balance = 100
    func deposit(_ amount: Int) {
        balance += amount
        print("Deposited \(amount), balance:", balance)
    }
}
let isolationTask = Task {
    print("Isolation demo")
    let account = BankAccount()
    await account.deposit(50)
    await account.deposit(30)
}

Thread.sleep(forTimeInterval: 2)

//senadable

struct User: Sendable {
    let name: String
}
let sendableTask = Task {
    print("Sendable demo")
    let user = User(name: "Alice")
    Task {
        print("Inner task got user:", user.name)
    }
}

Thread.sleep(forTimeInterval: 2)
