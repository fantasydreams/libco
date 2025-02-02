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


#ifndef __CO_ROUTINE_INNER_H__

#include "co_routine.h"
#include "coctx.h"
struct stCoRoutineEnv_t;  //一个线程中的协程环境
struct stCoSpec_t
{
	void *value;
};


//协程站内存
struct stStackMem_t
{
	stCoRoutine_t* occupy_co; //共享栈 指向现在占据本栈的协程
	int stack_size;
	char* stack_bp; //stack_buffer + stack_size
	char* stack_buffer;  //	stack 堆上首地址

};

struct stShareStack_t
{
	unsigned int alloc_idx;  // stack_array中我们在下一次调用中应该使用的那个共享栈的index
	int stack_size;			 // 
	int count;			     // sizeof(stack_array) / sizeof(stack_array[0])
	stStackMem_t** stack_array;  //协程栈的实际堆空间
};


//协程结构
struct stCoRoutine_t
{
	stCoRoutineEnv_t *env;  //本协程的执行环境
	pfn_co_routine_t pfn;	//协程的实际执行函数
	void *arg;				//协程函数的入餐参数
	coctx_t ctx;			//协程的CPU上下文

	char cStart;			//是否为协程的第一次执行
	char cEnd;				//协程是否结束
	char cIsMain;			//是否主协程  [libco的协程模型，主线程即为主协程，负责调度]
	char cEnableSysHook;	//是否开启系统hook
	char cIsShareStack;		//是否为共享栈

	void *pvEnv;  			//本协程独占私有区域

	//char sRunStack[ 1024 * 128 ];
	stStackMem_t* stack_mem; //协程栈 堆空间 128k


	//save satck buffer while confilct on same stack_buffer;
	char* stack_sp;  		//协程当前的栈顶指针
	unsigned int save_size;
	char* save_buffer;

	stCoSpec_t aSpec[1024];

};



//1.env
void 				co_init_curr_thread_env();
stCoRoutineEnv_t *	co_get_curr_thread_env();

//2.coroutine
void    co_free( stCoRoutine_t * co );
void    co_yield_env(  stCoRoutineEnv_t *env );

//3.func



//-----------------------------------------------------------------------------------------------

struct stTimeout_t;
struct stTimeoutItem_t ;

stTimeout_t *AllocTimeout( int iSize );
void 	FreeTimeout( stTimeout_t *apTimeout );
int  	AddTimeout( stTimeout_t *apTimeout,stTimeoutItem_t *apItem ,uint64_t allNow );

struct stCoEpoll_t;
stCoEpoll_t * AllocEpoll();
void 		FreeEpoll( stCoEpoll_t *ctx );

stCoRoutine_t *		GetCurrThreadCo();
void 				SetEpoll( stCoRoutineEnv_t *env,stCoEpoll_t *ev );

typedef void (*pfnCoRoutineFunc_t)();

#endif

#define __CO_ROUTINE_INNER_H__
