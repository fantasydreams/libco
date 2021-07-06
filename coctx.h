/*
* Tencent is pleased to support the open source community by making Libco available.

* Copyright (C) 2014 THL A29 Limited, a Tencent company. All rights reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License"); 
* you may not use this file except in compliance with the License. 
* You may obtain a copy of the License at
*
*	http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, 
* software distributed under the License is distributed on an "AS IS" BASIS, 
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
* See the License for the specific language governing permissions and 
* limitations under the License.
*/

#ifndef __CO_CTX_H__
#define __CO_CTX_H__
#include <stdlib.h>
typedef void* (*coctx_pfn_t)( void* s, void* s2 );
struct coctx_param_t
{
	const void *s1;
	const void *s2;
};

/* 几个寄存器 SS, SP, BP 三个寄存器
*  SS : 存放栈的段地址；
*  SP : 堆栈寄存器SP(stack pointer)存放栈的偏移地址;
*  BP : 基数指针寄存器BP(base pointer)是一个寄存器，它的用途有点特殊，
*       是和堆栈指针SP联合使用的，作为SP校准使用的，只有在寻找堆栈里的数据和使用个别的寻址方式时候才能用到
*/


//协程切换上下文保存
struct coctx_t
{
#if defined(__i386__)
	void *regs[ 8 ];
#else
	void *regs[ 14 ];
#endif
	size_t ss_size;  // stCoRoutine_t 中 stack_mem 协程栈 大小
	char *ss_sp;   	 //	stCoRoutine_t 中 stack_mem 协程栈 堆buffer首地址
	
};

/*
* 几个寄存器概念 ESP，EBP，EAX
* ESP: 栈指针寄存器(extended stack pointer)，其内存放着一个指针，该指针永远指向系统栈最上面一个栈帧的栈顶。  
* 由于栈的地址大小是从上到下从大到小，所以ESP指在栈的最底端。
* EBP: 基址指针寄存器(extended base pointer)，其内存放着一个指针，该指针永远指向系统栈最上面一个栈帧的底部。指在栈的最顶端。
* 
* EAX 一般用来保存函数的返回值
*/

int coctx_init( coctx_t *ctx );
int coctx_make( coctx_t *ctx,coctx_pfn_t pfn,const void *s,const void *s1 );
#endif
