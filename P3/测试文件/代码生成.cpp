#include<fstream>
#include<vector>
#include<algorithm>
#include<cstdlib>
#include<ctime>
using namespace std;
ofstream cout("test.txt");
struct op
{
	int type,r1,r2,r3;
	op(){}
	op(int a1,int a2,int a3,int a4){
		type=a1,r1=a2,r2=a3,r3=a4;
	}
};
int size_im,size_dm,size_op,small_reg;
op a[10010];
vector<int> branch[10010];
int is_small[40],small[40],val[40],cnt;
int r(int a,int b,int except1)//����1�żĴ���ʹ��ʱ���ܳ��ִ�����������ָ�����1�żĴ��� 
{
	int t0=rand()*2+rand()%2;
	int res=t0%(b-a+1)+a;
	return ((res==1)&&except1==1)?0:res;
}
int t[10010];
void get_small()//���ѡȡ���ɸ��Ĵ�������lw��sw�����ǵ�ֵС��dm��С�Ҳ��� 
{
	int i;
	for(i=1;i<=26;i++) t[i]=i;
	for(i=1;i<=26;i++) swap(t[i],t[rand()%30+1]);
	for(i=1;i<=small_reg;i++) small[i]=t[i]+1,is_small[t[i]+1]=1;
}
int nosmall()//���һ��������lw��sw�ļĴ��� 
{
	int u=r(0,27,1);
	while(is_small[u]==1){u=r(0,27,1);}
	return u;
}
void print(int x)
{
	if(a[x].type==0) cout<<"nop"<<endl;
	if(a[x].type==1) cout<<"addu $"<<a[x].r1<<",$"<<a[x].r2<<",$"<<a[x].r3<<endl;
	if(a[x].type==2) cout<<"subu $"<<a[x].r1<<",$"<<a[x].r2<<",$"<<a[x].r3<<endl;
	if(a[x].type==3) cout<<"lui $"<<a[x].r1<<","<<a[x].r3<<endl;
	if(a[x].type==4) cout<<"ori $"<<a[x].r1<<",$"<<a[x].r2<<","<<a[x].r3<<endl;
	if(a[x].type==5) cout<<"lw $"<<a[x].r1<<","<<a[x].r3<<"($"<<a[x].r2<<")"<<endl;
	if(a[x].type==6) cout<<"sw $"<<a[x].r1<<","<<a[x].r3<<"($"<<a[x].r2<<")"<<endl;
	if(a[x].type==7) cout<<"beq $"<<a[x].r1<<",$"<<a[x].r2<<",branch"<<a[x].r3<<endl;
}
int main()
{
	//0nop 1addu 2subu 3lui 4ori 5lw 6sw 7beq 
	int i,j;
	srand(time(0));
	size_im=128,size_dm=128,size_op=8,small_reg=8;		
	get_small();
	for(i=1;i<=small_reg;i++)
		a[i]=(op(4,small[i],0,val[small[i]]=r(0,size_dm-1,0)));
	for(i=small_reg+1;i<=size_im;i++)
	{
		int op0=r(0,size_op-1,0),r1,r2,r3;
		if(op0==0) a[i]=(op(0,0,0,0));
		if(op0==1||op0==2){//addu��subu 
			a[i]=op(op0,nosmall(),r(0,27,1),r(0,27,1));
		}
		if(op0==3||op0==4){//lui��ori 
			a[i]=(op(op0,nosmall(),r(0,27,1),r(0,65535,0)));
		}
		if(op0==5){//lw 
			r1=r(0,size_dm-1,0)*4;
			r2=r(1,small_reg,0);
			a[i]=(op(op0,nosmall(),small[r2],r1-val[small[r2]]));
		}
		if(op0==6){//sw 
			r1=r(0,size_dm-1,0)*4;
			r2=r(1,small_reg,0);
			a[i]=(op(op0,r(0,27,1),small[r2],r1-val[small[r2]]));
		}
		if(op0==7){//beq ����������ת���ܳ�����ѭ��������ֻ����������ת 
			r3=r(i,size_im,0);
			a[i]=(op(op0,r(0,27,1),r(0,27,1),++cnt));
			branch[r3].push_back(cnt);
		}
	}
	for(i=1;i<=size_im;i++)
	{
		print(i);
		for(j=0;j<branch[i].size();j++)
			cout<<"branch"<<branch[i][j]<<":"<<endl;
	}
}
