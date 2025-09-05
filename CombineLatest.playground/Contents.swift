import  Combine

let publisherA = PassthroughSubject<Int,Never>()
let publisherB = PassthroughSubject<String,Never>()

let cancellable = publisherA
    .combineLatest(publisherB)
    .sink { valueA, valueB in
        print("Combined: \(valueA), \(valueB)")
    }


publisherA.send(1)
publisherA.send(2)
publisherB.send("a")
publisherA.send(3)
publisherA.send(4)
publisherB.send("b")


// Prints:
//    Combined: 2, a   // pub1 latest = 2, pub2 latest = a
//    Combined: 3, a   // pub1 latest = 3, pub2 latest = a
//    Combined: 4, a   // pub1 latest = 4, pub2 latest = a
//    Combined: 4, b   // pub1 latest = 4, pub2 latest = b

