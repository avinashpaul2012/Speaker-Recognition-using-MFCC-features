clc;
close all;
clear;
Fs=11025;
mfle_=dir('C:\Users\hp\Desktop\bm_assgn\training\*.wav');
mfle_t=dir('C:\Users\hp\Desktop\bm_assgn\testing\*.wav');
l=length(mfle_);
lt=length(mfle_t);
splevec_=zeros(1,300);

    
for i=1:l
    f_nme=strcat('C:\Users\hp\Desktop\bm_assgn\training\',mfle_(i).name );
    [feature,~]=melcepst(audioread(f_nme));
    splevec_=reshape(feature',[1,numel(feature)]);
    siz_(i,:)=size(splevec_);
    data_1{i}=splevec_;  
end
labl_(1,1:30)=1;
c=1;
for i=1:l
    v1=size(data_1{i}); 
    if(mod(i-1,30)==0 && i<270)
        c=c+1;
        labl1_(1,1:30)=c;
        labl_=[labl_ labl1_];
    end
    if(v1(2)<max(siz_(:,2)))
        data_(i,:)=[data_1{i} zeros(1,(max(siz_(:,2))-v1(2)))];
    end         
end

for i=1:lt
    f_nmet=strcat('C:\Users\hp\Desktop\bm_assgn\testing\',mfle_t(i).name );
    [feature_t,~]=melcepst(audioread(f_nmet));
    splevec_t=reshape(feature_t',[1,numel(feature_t)]);
%     siz_t(i,:)=size(splevec_t);
    data_t{i}=splevec_t;
end
for i=1:lt
    v2=size(data_t{i});
    if(v2(2)<max(siz_(:,2)))
        data_ts(i,:)=[data_t{i} zeros(1,(max(siz_(:,2))-v2(2)))];
    end
end


for i=1:10
     mean_(i,:)=mean(data_((i-1)*30+1:30*i,:));
end
for k=1:30
    for i=1:l
        for j=1:10
            dis_(j)=sqrt(sum((data_(i,:)-mean_(j,:)).^2));
        end
        [m,I]=min(dis_);
        labl_(i)=I;
    end
    for m=1:10
        lab_pnt=[];
        poin_=find(labl_==m);
        for n=1:length(poin_)
            lab_pnt(n,:) = data_(poin_(n),:);
        end
        mean_(m,:)=mean(lab_pnt);
    end
    
end

%  testing by knn in testing
for i=1:lt
    for j=1:l
        dis_t(j)= sqrt(sum((data_ts(i,:)-data_(j,:)).^2));
    end
    lab_tp=[];
    for k=1:10
        minv_pt= find(dis_t==min(dis_t));
        lab_tp= [lab_tp labl_(minv_pt)];
        dis_t(minv_pt)= max(dis_t);
    end
    lab_f(i)=mode(lab_tp(1:10));
end
