clc
clear all

a=smlapp;

rosinit('127.0.0.1')

        state=rossubscriber('world_state');                                                                                                                            
        spawnclient = rossvcclient('/spawn_vehicle');
  spawnmsg = rosmessage(spawnclient);

%  spawnmsg.VehicleId=5;
% spawnmsg.V=5;                                                                                                                                                                                                                                              
spawnmsg.ToggleSim=true;
% spawnmsg.ClassName='DummyVehicle';
% spawnmsg.NodeId=-386;


while(1)
                                                                                                                                                            

scandata = receive(state);

[m n] = size(scandata.VehicleStates);

a.LinearGauge.Value=m;
if(a.ButtonPressed)
     
    spawnmsg.VehicleId=a.vehicleidvalue;
    spawnmsg.V=a.vehiclevelvalue;
    spawnmsg.NodeId=a.nodevalue; 
    spawnmsg.ClassName=a.vehicletypevalue;
    spawnresp = call(spawnclient,spawnmsg,'Timeout',3)
     
%      if(spawnresp)
%         disp('Vehicle Spawned');
%      end
%     fprintf('value is :- %d \n',a.vehicleidvalue);
    
    a.ButtonPressed=0;
end

scandata = receive(state);

if(a.selectedtabnum>0)
   
%      fprintf('Selected tab is :- %d \n',a.selectedtabnum);
    i=1;
     while(scandata.VehicleStates(i).VehicleId~=a.selectedtabnum)
         i=i+1;
     end
     
      a.gauges(a.selectedtabnum).Gauge.Value=scandata.VehicleStates(i).V;
      
%      a.Gauge.Value=scandata.VehicleStates(i).V;
                    
end
    
   



% pause(1);
end

rosshutdown