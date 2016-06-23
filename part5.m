clear all;

for j=1:5
    for i=1:50:1000
        errcounter(j,i)=projt(i);
        avgerrors(i)=sum(errcounter(:,i))/j;
    end

end

index=(1:length(avgerrors));
y=.1*index;
plot(index,avgerrors)
hold on;
plot(index,y)
xlabel('image set size')
ylabel('error count, average of 5 runs')
