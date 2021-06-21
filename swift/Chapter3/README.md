NSManagedObjectModel : .xcdatamodeld 파일에서 정의하는 객체의 모델

NSPersistentStore의 데이터 타입 종류
- NSSQLiteStoreType : nonatomic
- NSXMLStoreType : XML 기반, atomic
- NSBinaryStoreType : binary 기반, atomic
- NSInMemoryStoreType : 휘발성
- NSIncrementalStore : CSV, JSON 기반

NSPersistentStoreCoordinator : NSManagedObjectModel와 NSPersistentStore와 briging coordinator

NSManagedObjectContext
