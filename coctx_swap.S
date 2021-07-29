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

.globl coctx_swap
#if !defined( __APPLE__ )
.type  coctx_swap, @function
#endif
coctx_swap:

#if defined(__i386__)
    movl 4(%esp), %eax
    movl %esp,  28(%eax)
    movl %ebp, 24(%eax)
    movl %esi, 20(%eax)
    movl %edi, 16(%eax)
    movl %edx, 12(%eax)
    movl %ecx, 8(%eax)
    movl %ebx, 4(%eax)

    movl 8(%esp), %eax
    movl 4(%eax), %ebx
    movl 8(%eax), %ecx
    movl 12(%eax), %edx
    movl 16(%eax), %edi
    movl 20(%eax), %esi
    movl 24(%eax), %ebp
    movl 28(%eax), %esp

	ret

#elif defined(__x86_64__)
	  leaq (%rsp),%rax
    movq %rax, 104(%rdi)    
    movq %rbx, 96(%rdi)
    movq %rcx, 88(%rdi)
    movq %rdx, 80(%rdi)
	  movq (%rax), %rax
	  movq %rax, 72(%rdi) 
    movq %rsi, 64(%rdi)
	  movq %rdi, 56(%rdi)
    movq %rbp, 48(%rdi)
    movq %r8, 40(%rdi)
    movq %r9, 32(%rdi)
    movq %r12, 24(%rdi)
    movq %r13, 16(%rdi)
    movq %r14, 8(%rdi)
    movq %r15, (%rdi)
	  xorq %rax, %rax

    movq 48(%rsi), %rbp
    movq 104(%rsi), %rsp
    movq (%rsi), %r15
    movq 8(%rsi), %r14
    movq 16(%rsi), %r13
    movq 24(%rsi), %r12
    movq 32(%rsi), %r9
    movq 40(%rsi), %r8
    movq 56(%rsi), %rdi
    movq 80(%rsi), %rdx
    movq 88(%rsi), %rcx
    movq 96(%rsi), %rbx
		leaq 8(%rsp), %rsp
		pushq 72(%rsi)

    movq 64(%rsi), %rsi
	  ret
#endif

/*
*-------------
* 32 bit
* | regs[0]: ret |
* | regs[1]: ebx |
* | regs[2]: ecx |
* | regs[3]: edx |
* | regs[4]: edi |
* | regs[5]: esi |
* | regs[6]: ebp |
* | regs[7]: eax |  = esp


#if defined(__i386__)
    movl 4(%esp), %eax      ;eax = *(esp+4)  &(curr->ctx), +4个字节是因为push压栈上个函数的下一条指令的地址
    movl %esp,  28(%eax)    ;curr->ctx.regs[7] = esp  kESP，把esp保存到正在运行的协程指向上一个函数调用本函数后的第一条指令地址
    movl %ebp, 24(%eax)     ;curr->ctx.regs[6] = ebp
    movl %esi, 20(%eax)     ;curr->ctx.regs[5] = esi
    movl %edi, 16(%eax)     ;curr->ctx.regs[4] = edi
    movl %edx, 12(%eax)     ;curr->ctx.regs[3] = edx
    movl %ecx, 8(%eax)      ;curr->ctx.regs[2] = ecx
    movl %ebx, 4(%eax)      ;curr->ctx.regs[1] = ebx

    ;将要运行的coroutine 的上下问信息恢复到cpu
    movl 8(%esp), %eax      ;压栈从右往左，这里是 &(pending_co->ctx)
    movl 4(%eax), %ebx
    movl 8(%eax), %ecx
    movl 12(%eax), %edx
    movl 16(%eax), %edi
    movl 20(%eax), %esi
    movl 24(%eax), %ebp
    movl 28(%eax), %esp     ;去需要转去运行的协程栈的栈顶

	ret

#elif defined(__x86_64__)
	  leaq (%rsp),%rax        ;获取栈帧rsp所在的地址，搬运到rax
    movq %rax, 104(%rdi)    ;把栈顶指针存到co->ctx.reg[13]
    movq %rbx, 96(%rdi)     
    movq %rcx, 88(%rdi)
    movq %rdx, 80(%rdi)
	  movq (%rax), %rax       ;将pfb的地址取出来，即实际协程的worker函数指针。这里主协程不是pfn，而是co_swap调用coctx_swap后的第一条指令地址
	  movq %rax, 72(%rdi)     ;协程的实际worker函数
    movq %rsi, 64(%rdi)
	  movq %rdi, 56(%rdi)
    movq %rbp, 48(%rdi)     ;栈帧基指
    movq %r8, 40(%rdi)
    movq %r9, 32(%rdi)
    movq %r12, 24(%rdi)
    movq %r13, 16(%rdi)
    movq %r14, 8(%rdi)
    movq %r15, (%rdi)
	  xorq %rax, %rax         ;按位异或，相同的位置为0，不同的位置为1，rax和rax的每一位都相同，所以相当于清零。

    movq 48(%rsi), %rbp
    movq 104(%rsi), %rsp
    movq (%rsi), %r15
    movq 8(%rsi), %r14
    movq 16(%rsi), %r13
    movq 24(%rsi), %r12
    movq 32(%rsi), %r9
    movq 40(%rsi), %r8
    movq 56(%rsi), %rdi    ;恢复之前的rdi
    movq 80(%rsi), %rdx
    movq 88(%rsi), %rcx
    movq 96(%rsi), %rbx
		leaq 8(%rsp), %rsp    ;rsp回退一个g（2w），目的是改写rsp指向的函数指针达到改写rip的目的
		pushq 72(%rsi)        ;将需要执行的下一条指令改为协程的pfn，主协程为co_swap调用coctx_swap后的第一条指令地址

    movq 64(%rsi), %rsi   ;恢复之前的rsi
	  ret
#endif


* -------------
* 64 bit
* low | regs[0]: r15 |
*    | regs[1]: r14 |
*    | regs[2]: r13 |
*    | regs[3]: r12 |
*    | regs[4]: r9  |
*    | regs[5]: r8  |
*    | regs[6]: rbp |
*    | regs[7]: rdi |
*    | regs[8]: rsi |
*    | regs[9]: ret |  ;ret func addr
*    | regs[10]: rdx | ;R10, R11为callee saved register, 由被调用函数保存
*    | regs[11]: rcx |
*    | regs[12]: rbx |
* hig | regs[13]: rsp |


* 寄存器寻址
* movq %rax, %rdx
* 立即寻址
* movq $0x123, %edx
* 间接寻址
* movq (%rbx), %rax
* 变址寻址
* movq 8(%rax), %rdx
*/