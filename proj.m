%%Lawrence Yu
%%BME402 Memory Capacity Project
%%MAY 9, 2008

%%reading in the images
clear all;
close all;

a=dir('*.jpg');
for(i=1: length(a))
    names{i}=a(i).name;
    if(size(imread(names{i}),3)==3) %%check for greyscale
        im{i}=rgb2gray(imread(names{i}));
    else
        im{i}=imread(names{i});
    end
    imvecsunrnd{i} = double(reshape(im{i},numel(im{i}),1));
end

rndlist1=randperm(length(a)); %%used to randomize order of images
rndlist2=randperm(length(a)); %%random training order

for(i=1:length(a))%%randomize order of images
    imvecs{i}=imvecsunrnd{rndlist1(i)};
end

%assign target values
for(j=1:length(a))
    if(j<=(length(a)/2))
        target(j)=1;
    else
        target(j)=0;
    end
end

w(:,1)=randint(1024,1,-255,255); %random weight vector
e=1;
exit=0;
errcnt(e)=0;
while(exit~=1)
    for(i=1:length(a))
        analogresponse=dot(w(:,e),imvecs{rndlist2(i)});
        out=hardlim(analogresponse);
        analogplot(rndlist2(i),e)=analogresponse; %%record for plotting
        err=target(rndlist2(i))-out;

        w(:,e)=w(:,e)+err*imvecs{rndlist2(i)}; %perceptron learning rule
        if(err==1 || err==-1)
            errcnt(e)=errcnt(e) + 1;
        end
    end

    if(e>5) %check exit conditions
        avglast3=(errcnt(e)+errcnt(e-1)+errcnt(e-2))/3;
%         if(errcnt(e)>errcnt(e-4)) %%used to check last 5 error counts
            if(errcnt(e)==0)
            exit=1;
        end
    end
    if(exit~=1)
        w(:,e+1)=w(:,e);
        errcnt(e+1)=0;
        e=e+1;
    end
end

%%plotting training errors vs epoch
epochindex=[1:e];
figure, subplot(1,2,1);
plot(epochindex,errcnt,'bo');
title('errors over time');
xlabel('epoch');
ylabel('number of errors');


%%plotting the analog response
errorindex=[1:length(imvecs)];
laste=length(errcnt);
figure, subplot(1,2,1);
bar(errorindex,analogplot(:,laste))
title(['epoch ', num2str(laste), ', number of errors = ', num2str(errcnt(laste))])
xlabel('picture number')
ylabel('analog response')

% % plot the weight vector
% wshow=reshape(w(:,4),32,32);
% figure, imagesc(wshow);