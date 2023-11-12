import UIKit

protocol ActorProviding {
    static func makeDataActor() -> DataActing
}

final public class ActorFactory: ActorProviding {
    private static var persistanceActor: PersistanceActor? = nil
    
    static func makeDataActor() -> DataActing {
        return DataActor()
    }
    
    static func makePersitanceActor() -> PersistanceActing {
        if persistanceActor == nil {
            persistanceActor = PersistanceActor()
        }
        
        return persistanceActor!
    }
}
