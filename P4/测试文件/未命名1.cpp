#include <bits/stdc++.h>
#include <iostream>
using namespace std;
mt19937 rng(time(0));
struct instr
{
    int type, r1, r2, r3, aux;
} data1[1010], helper[10010];
int acnt;
struct blo
{
    int type, lines, r1, r2;
} data2[20];
int interval[100];
int tot_blo, tot_lines;
int rand_range(int l, int r, bool exp) // refered from wzy,to avoid $1
{
    int len = r - l + 1;
    int t = l + (rng() % len + len) % len;
    return ((exp == true) ? (t != 1 ? t : 0) : t);
}
void pre_fill()
{
    // fill the registers
    for (int i = 2; i <= 27; i++)
    {
        printf("lui $%d,%d\n", i, rand_range(0, 65535, false));
        printf("ori $%d,$%d,%d\n", i, i, rand_range(0, 65535, false));
    }
    // fill the memories
    for (int i = 0; i <= 100; i++)
    {
        printf("sw $%d,%d($%d)\n", rand_range(0, 27, true), i * 4, 0);
    }
}
void print_instr(int x)
{
    int y;
    if (data1[x].type == 1)
        printf("addu $%d,$%d,$%d\n", data1[x].r1, data1[x].r2, data1[x].r3);
    else if (data1[x].type == 2)
        printf("subu $%d,$%d,$%d\n", data1[x].r1, data1[x].r2, data1[x].r3);
    else if (data1[x].type == 3)
        printf("ori $%d,$%d,%d\n", data1[x].r1, data1[x].r2, data1[x].r3);
    else if (data1[x].type == 4)
        printf("lui $%d,%d\n", data1[x].r1, data1[x].r2);
    else if (data1[x].type == 5)
        printf("nop\n");
    else if (data1[x].type == 6)
    {
        y = data1[x].aux;
        printf("ori $%d,$0,%d\n", helper[y].r1, helper[y].r2);
        printf("lw $%d,%d($%d)\n", data1[x].r1, data1[x].r3, data1[x].r2);
    }
    else if (data1[x].type == 7)
    {
        y = data1[x].aux;
        printf("ori $%d,$0,%d\n", helper[y].r1, helper[y].r2);
        printf("sw $%d,%d($%d)\n", data1[x].r1, data1[x].r3, data1[x].r2);
    }
}
int main()
{
    pre_fill();
    tot_blo = rand_range(1, 15, false);
    for (int i = 1; i <= tot_blo; i++)
    {
        data2[i].type = rng() % 2;
        data2[i].lines = rand_range(1, 20, false);
        tot_lines += data2[i].lines;
    }
    for (int i = 1; i <= tot_blo + 1; i++)
    {
        interval[i] = rand_range(1, 20, false);
        tot_lines += interval[i];
    }
    for (int i = 1; i <= tot_lines; i++)
    {
        data1[i].type = rand_range(1, 7, false);      //5 for nop
        if (data1[i].type == 1 || data1[i].type == 2) //addu & subu
        {
            data1[i].r1 = rand_range(0, 27, true);
            data1[i].r2 = rand_range(0, 27, true);
            data1[i].r3 = rand_range(0, 27, true);
        }
        else if (data1[i].type == 3) //ori
        {
            data1[i].r1 = rand_range(0, 27, true);
            data1[i].r2 = rand_range(0, 27, true);
            data1[i].r3 = rand_range(0, 65535, false);
        }
        else if (data1[i].type == 4) //lui
        {
            data1[i].r1 = rand_range(0, 27, true);
            data1[i].r2 = rand_range(0, 65535, false);
        }
        else if (data1[i].type == 6 || data1[i].type == 7)
        {
            data1[i].aux = ++acnt;
            helper[acnt].r1 = rand_range(2, 27, true);       // base reg
            helper[acnt].r2 = 4 * rand_range(0, 100, false); // imm
            data1[i].r1 = rand_range(0, 27, true);
            data1[i].r2 = helper[acnt].r1; //base reg
            if (helper[acnt].r2 >= 50)
                data1[i].r3 = -4 * rand_range(0, 12, false);
            else
                data1[i].r3 = 4 * rand_range(0, 12, false);
        }
    }
    int coin;
    for (int i = 1; i <= tot_blo; i++)
    {
        if (data2[i].type == 0) // beq
        {
            coin = rng() % 3;
            if (coin != 0) //==,increase the probability
            {
                data2[i].r1 = data2[i].r2 = rand_range(0, 27, true);
            }
            else
            {
                data2[i].r1 = rand_range(0, 27, true);
                data2[i].r2 = rand_range(0, 27, true);
            } //!=
        }
    }
    int k = 0;
    printf("ori $31,$0,0x00003F00\n"); //set the $ra
    printf("ori $29,$0,0x00002F00\n"); //set the $sp
    for (int i = 1; i <= tot_blo; i++)
    {
        for (int j = 1; j <= interval[i]; j++)
        {
            k++;
            print_instr(k);
        }
        if (data2[i].type == 0)
        {
            printf("beq $%d,$%d,branch%d\n", data2[i].r1, data2[i].r2, i);
            for (int j = 1; j <= data2[i].lines; j++)
            {
                k++;
                print_instr(k);
            }
            printf("branch%d:\n", i);
        }
        else
        {
            printf("ori $2,$0,4\n");
            printf("subu $sp,$sp,$2\n");
            printf("sw $ra,4($sp)\n");
            printf("jal func%d\n", i);
            printf("ori $2,$0,4\n");
            printf("lw $ra,4($sp)\n");
            printf("addu $sp,$sp,$2\n");
        }
    }
    printf("jr $ra\n"); // to end the program (with error)
    for (int i = 1; i <= tot_blo; i++)
        if (data2[i].type == 1)
        {
            printf("func%d:\n", i);
            for (int j = 1; j <= data2[i].lines; j++)
            {
                k++;
                print_instr(k);
            }
            printf("jr $ra\n");
        }
    return 0;
}
