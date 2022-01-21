-- Raptors library version 0.1


function SpawnWithPenality(unitGroupName, reSpawnEvent, penality, coalition, onEventMessage, onRespawnMessage)

 SPAWN
  :New(unitGroupName)
  :OnSpawnGroup(function(SpawnGroup)
      SpawnGroup:HandleEvent(reSpawnEvent)
      function SpawnGroup:OnEventCrash(EventData)
         MESSAGE:New(onEventMessage):ToCoalition(coalition)
         SCHEDULER:New(nil,function() 
          SpawnWithPenality(unitGroupName, reSpawnEvent, penality, coalition, onEventMessage, onRespawnMessage)
          MESSAGE:New(unitGroupName .. " " .. onRespawnMessage):ToCoalition(coalition)
        end,{}, penality, 0, penality)
      end
    end
  ) 
  :Spawn() 

end


function SpawnTemplateInRandomZone(unitGroupName, unitTemplate, spawnZone, reSpawnEvent, penality, coalition)
    
    SPAWN:New(unitGroupName)
         :InitLimit(3*5, 3)
         :InitRandomizeTemplate()
         --:InitRandomizeRoute(0, 8, 1000)
         :InitRandomizeZones({
            ZONE:New("BLUE_SHIP_SPAWN1"),
         })
         :OnSpawnGroup(function(SpawnGroup)
            SpawnGroup:HandleEvent(EVENTS.Dead)
            function SpawnGroup:OnEventDead(EventData)
               MESSAGE:New("Enemy (training) ship group is dead. Next respawn will be after " .. penality .. " seconds."):ToCoalition(coalition.side.BLUE)
               SCHEDULER:New(nil,function() 
                SpawnBlueTrainingAirDefence1(penality)
                MESSAGE:New("Enemy (training) ship group has been respawned."):ToCoalition(coalition.side.RED)
              end,{}, penality, 0, penality)
            end
          end
        )
         :InitCleanUp(1*60*60)
         --:SpawnScheduled(1,0) 
         :Spawn() 
 
end

local unitTemplate = {
            "BLUE_GENERAL1",
            "BLUE_CARGO1",
         }
         
SpawnTemplateInRandomZone("SPAWN UNIT", unitTemplate, spawnZone, reSpawnEvent, penality, coalition)

