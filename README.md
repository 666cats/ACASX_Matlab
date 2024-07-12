## ACASX Cost Table 和 entry Table生成
此MATLAB代码是对ACAS_CPP仓库内容的移植改写，原仓库连接如下

https://github.com/xueyizou/ACASX_CPlusPlus
原仓库Double 2D函数的resize函数存在问题，分子分母的顺序存在错误，请大家留意

### MDP
MDP 开头的一系列文件负责生成
* IndexFile 序号表
* ActionFile 动作表
* CostFile 代价表

### DTMC
DTMC 开头的一系列文件生成
* entryTimeDistubutionFile 时间tau的分布表
