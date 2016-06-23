
function out = projt(limit)

a=ones(1,limit);
for(i=1:length(a))
    imvecs{i}=double(randint(1024,1,0,255)); %white noise image
end

rndlist=randperm(length(imvecs));
%%randomize list and assign target values
for(j=1:length(a))
    if(j<=(length(a)/2))
        target(rndlist(j))=1;
    else
        target(rndlist(j))=0;
    end
end

w(:,1)=randint(1024,1,-255,255); %random training vector
e=1;
exit=0;
errcnt(e)=0;
while(exit~=1)
    for(i=1:length(a))
        analogresponse=dot(w(:,e),imvecs{rndlist(i)});
        out=hardlim(analogresponse);
%         analogplot(i,e)=analogresponse; %%record for plotting
        err=target(i)-out;
        w(:,e)=w(:,e)+err*imvecs{rndlist(i)};
        if(err==1 || err==-1)
            errcnt(e)=errcnt(e) + 1;
        end
    end

    if(e>5) %check exit conditions
        %avglast3=(errcnt(e)+errcnt(e-1)+errcnt(e-2))/3;
        avglast5=(errcnt(e)+errcnt(e-1)+errcnt(e-2)+errcnt(e-3)+errcnt(e-4))/5;
        out = avglast5;
        if((errcnt(e)>errcnt(e-4)) || errcnt(e)==0 )
        %if(errcnt(e)==0)
            exit=1;
        end
    end
    if(exit~=1)
        w(:,e+1)=w(:,e);
        errcnt(e+1)=0;
        e=e+1;
    end
end

end
