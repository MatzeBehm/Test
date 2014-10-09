function [ chirp_data ] = BinaryRead( filename )
%Lese Binäre digitale Empfängerdaten
%Die Daten bestehen aus 5 Spalten mit je 2048 Werten die Anzahl der Rampen
%hintereinander kann variieren. In Spalte 1 steht die Rampennummer; Spalte
%2 ist Kanal 1, Spalte 3 Kanal 2 usw. 

fid = fopen(filename);
chirp_data = fread(fid, [6 inf],'*short');
fclose(fid);
chirp_data= chirp_data';
%a= zeros(1,2,3)
end

