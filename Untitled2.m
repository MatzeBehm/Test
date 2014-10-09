% for index=1:length(Test11)
%     if Test11(index,1)<=0 && Test11(index,1)>=-0.1
%         for ii=1:128
%              a(ii,:)=Test11(index,:);
%              index=index+1;
%         end
%     end 
% end


index=1;
winkel=4;
while Test11(index,1)>=winkel+0.05 || Test11(index,1)<=winkel-0.05  
    index=index+1;
    %disp('test');
end
a=Test11(index:index+128*2048,:);