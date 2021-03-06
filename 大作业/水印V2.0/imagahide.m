function  count=imagahide(cover,massage,goleimage,goleimage1,permission,permission1,level,threshold)
%提取图像信息并分层
% cover='314745.jpg';
% massage='lena512.bmp';
% goleimage='zaimi.bmp';
% permission='bmp';
% permission1='jpg';
% level=3;
% threshold=0.7;
cover = imread(cover,permission1);
data=cover;
msg=imread(massage,permission);
cover1=cover(:,:,level);
%对cover和msg的第4bit进行处理
tempc=cover1;
tempm=msg;
tempc=bitand(tempc,8);
tempm=bitand(tempm,8);
temp=bitxor(tempm,tempc);
[row,col]=size(temp);
%记录图像每个分块的n值
k1=0;
k2=0;
a=row*col/64;
count=zeros([1 a]);
for i=1:a
    for m=1:8
        for n=1:8
            if temp(8*k1+m,8*k2+n)==0
                count(1,i)=count(1,i)+1;
            end
        end
    end
    k2=k2+1;
    if k2*8==col
       k2=0;
       k1=k1+1;
    end
end
%计算每块的μ值并与阈值进行比较
count=count/64;
k3=0;
k4=0;
data1=imread(goleimage,permission);
data2=imread(goleimage1,permission);
A=data1(:,:,level);
B=data2(:,:,level);
for i=1:a
    if count(i)>=threshold
        count(i)=1;%可以替换
        for m=1:8
            for n=1:8
                A(8*k3+m,8*k4+n)=bitand(A(8*k3+m,8*k4+n),15);
            end
        end
     else if count(i)<1-threshold
        count(i)=-1;%可以替换
        for m=1:8
            for n=1:8
                %差
                %B(8*k3+m,8*k4+n)=bitand(B(8*k3+m,8*k4+n),15);
                %A(8*k3+m,8*k4+n)=B(8*k3+m,8*k4+n);
                A(8*k3+m,8*k4+n)=bitand(A(8*k3+m,8*k4+n),15);
                A(8*k3+m,8*k4+n)=bitxor(A(8*k3+m,8*k4+n),8);
            end
        end
    else 
        count(i)=0;%可以替换
        for m=1:8
            for n=1:8
                %
                B(8*k3+m,8*k4+n)=bitand(B(8*k3+m,8*k4+n),15);
                A(8*k3+m,8*k4+n)=B(8*k3+m,8*k4+n);
                %A(8*k3+m,8*k4+n)=bitand(A(8*k3+m,8*k4+n),7);
            end
        end
    k4=k4+1;
    if k4*8==col
       k4=0;
       k3=k3+1;
    end
        end
    end
        
   
%      A=bitshift(A,4);

%     %提取秘密图像信息,检测隐藏效果
%     data=imread(goleimage,permission);
%     [row,col]=size(data);
%     A=data(:,:,level);
%     for i=1:row
%         for j=1:col/3
%             A(i,j)=bitand(A(i,j),15);
%         end
%     end
%     A=bitshift(A,4);
% subplot(221),imshow(cover);title('载体图像');
% subplot(222),imshow(massage);title('秘密图像');
% subplot(223),imshow(data);title('隐藏后的图像');
% subplot(224),imshow(A);title('提取的秘密图像');
%data=imagehide(cover,massage,goleimage,permission,permission1,level);
%提取秘密图像信息,检测隐藏效果
% data=imread(goleimage,permission);
% [row,col]=size(data);
% B=data(:,:,level);
% for i=1:row
%     for j=1:col/3
%        B(i,j)=bitand(B(i,j),15);
%     end
% end
% B=bitshift(B,4);
%data=imagehide(cover,massage,goleimage,permission,permission1,level);
end
A=bitshift(A,4);
subplot(221),imshow(cover);title('载体图像');
subplot(222),imshow(massage);title('秘密图像');
subplot(223),imshow(data);title('隐藏后的图像');
subplot(224),imshow(A);title('提取的秘密图像');