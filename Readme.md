share(replay: 1, scope: .whileConnected)는 옵저버블이 커넥트 된 동안에만 replay를 한다. 즉 커넥트가 전부 끊어지면 replay 이벤트는 날라간다. 

share(replay: 1, scope: .forever)는 옵저버블이 커넥트가 전부 끊어지더라도 이전 이벤트를 replay 한다. 