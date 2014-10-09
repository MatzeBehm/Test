function [ DataMatrixCh1,DataMatrixCh2,DataMatrixCh3,DataMatrixCh4 ] = GetData4Winkel(data,motorwinkel,numberOfChirps,numberOfSamples )
%UNTITLED Summary of this function goes here
%   durchsucht Datenarray und gibt die 4 Channel-Matritzen für alle 128 Chirps zurück für einen eingestellten Motor-
%   Winkel zurück. Die Funktion dient zur Auswertung der Messbox: agethen
%   2014-05-27

anz_winkelschritte=length(data)/(numberOfChirps*numberOfSamples);
start_winkel=data(1,1);
end_winkel=data(length(data),1);

spanne_winkel_gesamt=0;
for i=start_winkel:1:end_winkel+1
    spanne_winkel_gesamt=spanne_winkel_gesamt+1;
end

schrittweite_winkel=spanne_winkel_gesamt/anz_winkelschritte

spanne_winkel_gesucht=0;

for i=start_winkel:schrittweite_winkel:motorwinkel
    spanne_winkel_gesucht=spanne_winkel_gesucht+1
end

start_point_for_data=(spanne_winkel_gesucht*numberOfChirps*numberOfSamples)+1;

range_winkel_in_data=(numberOfChirps*numberOfSamples)-1;

winkel=motorwinkel;


if nargin<=2
    disp('Nargin<=2');
    numberOfChirps=128;
    numberOfSamples=2048;
end ,

DataMatrixCh1=zeros(numberOfSamples,numberOfChirps);
DataMatrixCh2=zeros(numberOfSamples,numberOfChirps);
DataMatrixCh3=zeros(numberOfSamples,numberOfChirps);
DataMatrixCh4=zeros(numberOfSamples,numberOfChirps);
range_chirp_in_data=numberOfSamples;
  
    start_value=start_point_for_data
        if data(start_point_for_data,1)>=winkel-0.05 && data(start_point_for_data,1)<=winkel+0.05  
            for ii=1:128
                DataMatrixCh1(:,ii)=data(start_value:start_value+numberOfSamples-1,3);
                DataMatrixCh2(:,ii)=data(start_value:start_value+numberOfSamples-1,4);
                DataMatrixCh3(:,ii)=data(start_value:start_value+numberOfSamples-1,5);
                DataMatrixCh4(:,ii)=data(start_value:start_value+numberOfSamples-1,6);
                start_value=start_value+numberOfSamples;
                
            end
          
        end
   

end

