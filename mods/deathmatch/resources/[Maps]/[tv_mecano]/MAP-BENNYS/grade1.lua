function createTheGate ()
 
         myGate1 = createObject ( 1902, 2284.2001953125, -1983.2001953125, 13.199999809265 , 0, 0, 0 )

 
      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )
 
 
 
 
 
 function openMyGate ( )
 moveObject ( myGate1, 2500, 2284.1999511719, -1983.1999511719,8.1000003814697 )
 end
 addCommandHandler("bennys01",openMyGate)
 
 
 function movingMyGateBack ()
 moveObject ( myGate1, 2500, 2284.2001953125, -1983.2001953125, 13.199999809265 )
 end
 addCommandHandler("bennys02",movingMyGateBack)