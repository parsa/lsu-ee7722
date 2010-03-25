
	.section	".text",#alloc,#execinstr,#progbits
	.file	"hash.c"

	.section	".bss",#alloc,#write,#nobits

Bbss.bss:

	.section	".data",#alloc,#write,#progbits

Ddata.data:

	.section	".rodata",#alloc,#progbits
!
! CONSTANT POOL
!

Drodata.rodata:

	.section	".rodata1",#alloc,#progbits
	.align	4
!
! CONSTANT POOL
!

.L24:
	.ascii	"table\000"
	.align	4
!
! CONSTANT POOL
!

.L25:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L45:
	.ascii	"table\000"
	.align	4
!
! CONSTANT POOL
!

.L46:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L51:
	.ascii	"key\000"
	.align	4
!
! CONSTANT POOL
!

.L52:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L69:
	.ascii	"table\000"
	.align	4
!
! CONSTANT POOL
!

.L70:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L75:
	.ascii	"key\000"
	.align	4
!
! CONSTANT POOL
!

.L76:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L95:
	.ascii	"table\000"
	.align	4
!
! CONSTANT POOL
!

.L96:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L101:
	.ascii	"key\000"
	.align	4
!
! CONSTANT POOL
!

.L102:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L122:
	.ascii	"table\000"
	.align	4
!
! CONSTANT POOL
!

.L123:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L140:
	.ascii	"table\000"
	.align	4
!
! CONSTANT POOL
!

.L141:
	.ascii	"hash.c\000"
	.align	4
!
! CONSTANT POOL
!

.L151:
	.ascii	"%u %p\n\000"

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
! FILE hash.c

!    1		      !/* $Id: hash.c,v 1.3 1997/09/22 02:33:07 brianp Exp $ */
!    3		      !/*
!    4		      ! * Mesa 3-D graphics library
!    5		      ! * Version:  2.5
!    6		      ! * Copyright (C) 1995-1997  Brian Paul
!    7		      ! *
!    8		      ! * This library is free software; you can redistribute it and/or
!    9		      ! * modify it under the terms of the GNU Library General Public
!   10		      ! * License as published by the Free Software Foundation; either
!   11		      ! * version 2 of the License, or (at your option) any later version.
!   12		      ! *
!   13		      ! * This library is distributed in the hope that it will be useful,
!   14		      ! * but WITHOUT ANY WARRANTY; without even the implied warranty of
!   15		      ! * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!   16		      ! * Library General Public License for more details.
!   17		      ! *
!   18		      ! * You should have received a copy of the GNU Library General Public
!   19		      ! * License along with this library; if not, write to the Free
!   20		      ! * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!   21		      ! */
!   24		      !/*
!   25		      ! * $Log: hash.c,v $
!   26		      ! * Revision 1.3  1997/09/22 02:33:07  brianp
!   27		      ! * added HashRemove() and HashFirstEntry()
!   28		      ! *
!   29		      ! * Revision 1.2  1997/09/03 13:13:45  brianp
!   30		      ! * added a few pointer casts
!   31		      ! *
!   32		      ! * Revision 1.1  1997/08/22 01:15:10  brianp
!   33		      ! * Initial revision
!   34		      ! *
!   35		      ! */
!   38		      !#ifdef PC_HEADER
!   39		      !#include "all.h"
!   40		      !#else
!   41		      !#include <assert.h>
!   42		      !#include <stdlib.h>
!   43		      !#include <stdio.h>
!   44		      !#include "hash.h"
!   45		      !#endif
!   48		      !/*
!   49		      ! * Generic hash table.  Only dependency is the GLuint datatype.
!   50		      ! *
!   51		      ! * This is used to implement display list and texture object lookup.
!   52		      ! * NOTE: key=0 is illegal.
!   53		      ! */
!   56		      !#define TABLE_SIZE 1001
!   58		      !struct HashEntry {
!   59		      !   GLuint Key;
!   60		      !   void *Data;
!   61		      !   struct HashEntry *Next;
!   62		      !};
!   64		      !struct HashTable {
!   65		      !   struct HashEntry *Table[TABLE_SIZE];
!   66		      !   GLuint MaxKey;
!   67		      !};
!   71		      !/*
!   72		      ! * Return pointer to a new, empty hash table.
!   73		      ! */
!   74		      !struct HashTable *NewHashTable(void)
!   75		      !{
!   76		      !   return (struct HashTable *) calloc(sizeof (struct HashTable), 1);

!
! SUBROUTINE NewHashTable
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global NewHashTable
                       

			NewHashTable:
/* 000000	  76 */		or	%g0,%o7,%g1
/* 0x0004	     */		or	%g0,1,%o1
/* 0x0008	     */		or	%g0,4008,%o0
/* 0x000c	     */		call	calloc	! params =  %o0 %o1	! Result = 	! (tail call)
/* 0x0010	     */		or	%g0,%g1,%o7
/* 0x0014	   0 */		.type	NewHashTable,2
/* 0x0014	   0 */		.size	NewHashTable,(.-NewHashTable)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!   77		      !}
!   81		      !/*
!   82		      ! * Delete a hash table.
!   83		      ! */
!   84		      !void DeleteHashTable(struct HashTable *table)
!   85		      !{

!
! SUBROUTINE DeleteHashTable
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global DeleteHashTable
                       

			DeleteHashTable:
/* 000000	  85 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i0,%i0

!   86		      !   GLuint i;
!   87		      !   assert(table);

/* 0x0008	  87 */		be,pn	%icc,.L77000449

!   88		      !   for (i=0;i<TABLE_SIZE;i++) {

/* 0x000c	  88 */		or	%g0,0,%i4

! Registers live out of DeleteHashTable: 
! o2 sp i0 i4 fp i7 gsr 
! 
		
!   89		      !      struct HashEntry *entry = table->Table[i];

                       
! predecessor blocks: .L77000449 DeleteHashTable

			.L77000459:
/* 0x0010	  89 */		sll	%i4,2,%i5

! Registers live out of .L77000459: 
! sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000459 .L77000467

			.L900000205:
/* 0x0014	  89 */		ld	[%i5+%i0],%i5

!   90		      !      while (entry) {

/* 0x0018	  90 */		cmp	%i5,0
/* 0x001c	     */		be,pn	%icc,.L77000467
/* 0x0020	  92 */		or	%g0,%i5,%o0

! Registers live out of .L900000205: 
! o0 sp i0 i4 i5 fp i7 gsr 
! 
		
!   91		      !	 struct HashEntry *next = entry->Next;
!   92		      !	 free(entry);

                       
! predecessor blocks: .L900000205 .L900000206

			.L900000206:
/* 0x0024	  92 */		call	free	! params =  %o0	! Result = 
/* 0x0028	  91 */		ld	[%i5+8],%i5
/* 0x002c	  90 */		cmp	%i5,0
/* 0x0030	     */		bne,pt	%icc,.L900000206
/* 0x0034	  92 */		or	%g0,%i5,%o0

! Registers live out of .L900000206: 
! o0 sp i0 i4 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000205 .L900000206

			.L77000467:
/* 0x0038	  88 */		add	%i4,1,%i4
/* 0x003c	     */		cmp	%i4,1001
/* 0x0040	     */		bcs,pt	%icc,.L900000205
/* 0x0044	  89 */		sll	%i4,2,%i5

! Registers live out of .L77000467: 
! sp i0 i4 i5 fp i7 gsr 
! 
		
!   93		      !	 entry = next;
!   94		      !      }
!   95		      !   }
!   96		      !   free(table);

                       
! predecessor blocks: .L77000467

			.L77000471:
/* 0x0048	  96 */		call	free	! params =  %i0	! Result = 	! (tail call)
/* 0x004c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: DeleteHashTable

			.L77000449:
/* 0x0050	  87 */		sethi	%hi(.L25),%i3
/* 0x0054	     */		sethi	%hi(.L24),%i2
/* 0x0058	     */		add	%i3,%lo(.L25),%o1
/* 0x005c	     */		add	%i2,%lo(.L24),%o0
/* 0x0060	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x0064	     */		or	%g0,87,%o2
/* 0x0068	     */		ba	.L77000459
/* 0x006c	  88 */		or	%g0,0,%i4

! Registers live out of .L77000449: 
! sp i0 i4 fp i7 gsr 
! 
		/* 0x0070	   0 */		.type	DeleteHashTable,2
/* 0x0070	   0 */		.size	DeleteHashTable,(.-DeleteHashTable)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!   97		      !}
!  101		      !/*
!  102		      ! * Lookup an entry in the hash table.
!  103		      ! * Input:  table - the hash table
!  104		      ! *         key - the key
!  105		      ! * Return:  user data pointer or NULL if key not in table
!  106		      ! */
!  107		      !void *HashLookup(const struct HashTable *table, GLuint key)
!  108		      !{

!
! SUBROUTINE HashLookup
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global HashLookup
                       

			HashLookup:
/* 000000	 108 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i0,%i0

!  109		      !   GLuint pos;
!  110		      !   struct HashEntry *entry;
!  112		      !   assert(table);

/* 0x0008	 112 */		be,pn	%icc,.L77000498
/* 0x000c	 113 */		cmp	%i1,0

! Registers live out of HashLookup: 
! o2 sp i0 i1 fp i7 gsr 
! 
		
!  113		      !   assert(key);

                       
! predecessor blocks: .L77000498 HashLookup

			.L900000310:
/* 0x0010	 113 */		be,pn	%icc,.L77000506
/* 0x0014	 116 */		sethi	%hi(0x5e1d000),%o7

! Registers live out of .L900000310: 
! o2 sp o7 i0 i1 fp i7 gsr 
! 
		
!  115		      !   pos = key % TABLE_SIZE;
!  116		      !   entry = table->Table[pos];

                       
! predecessor blocks: .L77000506 .L900000310

			.L900000309:
/* 0x0018	 116 */		add	%o7,635,%o5
/* 0x001c	     */		srl	%i1,0,%o4
/* 0x0020	     */		mulx	%o4,%o5,%o3
/* 0x0024	     */		srlx	%o3,32,%i3
/* 0x0028	     */		sub	%i1,%i3,%i4
/* 0x002c	     */		srl	%i4,1,%i2
/* 0x0030	     */		add	%i3,%i2,%l7
/* 0x0034	     */		srl	%l7,4,%l6
/* 0x0038	     */		srl	%l7,9,%l0
/* 0x003c	     */		and	%l6,-32,%l5
/* 0x0040	     */		sub	%l5,%l0,%l4
/* 0x0044	     */		sll	%l4,2,%l3
/* 0x0048	     */		add	%l0,%l3,%l2
/* 0x004c	     */		sll	%l2,3,%l1
/* 0x0050	     */		add	%l0,%l1,%o2
/* 0x0054	     */		sub	%i1,%o2,%o1
/* 0x0058	     */		sll	%o1,2,%o0
/* 0x005c	     */		ld	[%i0+%o0],%g5

!  117		      !   while (entry) {

/* 0x0060	 117 */		cmp	%g5,0
/* 0x0064	     */		be,pn	%icc,.L77000525

!  118		      !      if (entry->Key == key) {
!  119		      !	 return entry->Data;
!  120		      !      }
!  121		      !      entry = entry->Next;
!  122		      !   }
!  123		      !   return NULL;

/* 0x0068	 123 */		or	%g0,0,%i0

! Registers live out of .L900000309: 
! g5 sp i0 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000309

			.L77000516:
/* 0x006c	 118 */		ld	[%g5],%i5

! Registers live out of .L77000516: 
! g5 sp i0 i1 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000516 .L77000520

			.L900000311:
/* 0x0070	 118 */		cmp	%i5,%i1
/* 0x0074	     */		be,a,pn	%icc,.L77000525
/* 0x0078	 119 */		ld	[%g5+4],%i0

! Registers live out of .L900000311: 
! g5 sp i0 i1 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000311

			.L77000520:
/* 0x007c	 121 */		ld	[%g5+8],%g5
/* 0x0080	 117 */		cmp	%g5,0
/* 0x0084	     */		bne,a,pt	%icc,.L900000311
/* 0x0088	 118 */		ld	[%g5],%i5

! Registers live out of .L77000520: 
! g5 sp i0 i1 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000520

			.L77000524:
/* 0x008c	 123 */		or	%g0,0,%i0

! Registers live out of .L77000524: 
! sp i0 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000524 .L900000309 .L900000311

			.L77000525:
/* 0x0090	 123 */		ret	! Result =  %i0
/* 0x0094	     */		restore	%g0,0,%g0
                       
! predecessor blocks: HashLookup

			.L77000498:
/* 0x0098	 112 */		sethi	%hi(.L46),%g2
/* 0x009c	     */		sethi	%hi(.L45),%g1
/* 0x00a0	     */		add	%g2,%lo(.L46),%o1
/* 0x00a4	     */		add	%g1,%lo(.L45),%o0
/* 0x00a8	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x00ac	     */		or	%g0,112,%o2
/* 0x00b0	     */		ba	.L900000310
/* 0x00b4	 113 */		cmp	%i1,0

! Registers live out of .L77000498: 
! o2 sp i0 i1 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000310

			.L77000506:
/* 0x00b8	 113 */		sethi	%hi(.L52),%g4
/* 0x00bc	     */		sethi	%hi(.L51),%g3
/* 0x00c0	     */		add	%g4,%lo(.L52),%o1
/* 0x00c4	     */		add	%g3,%lo(.L51),%o0
/* 0x00c8	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x00cc	     */		or	%g0,113,%o2
/* 0x00d0	     */		ba	.L900000309
/* 0x00d4	 116 */		sethi	%hi(0x5e1d000),%o7

! Registers live out of .L77000506: 
! sp o7 i0 i1 fp i7 gsr 
! 
		/* 0x00d8	   0 */		.type	HashLookup,2
/* 0x00d8	   0 */		.size	HashLookup,(.-HashLookup)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!  124		      !}
!  128		      !/*
!  129		      ! * Insert into the hash table.  If an entry with this key already exists
!  130		      ! * we'll replace the existing entry.
!  131		      ! * Input:  table - the hash table
!  132		      ! *         key - the key (not zero)
!  133		      ! *         data - pointer to user data
!  134		      ! */
!  135		      !void HashInsert(struct HashTable *table, GLuint key, void *data)
!  136		      !{

!
! SUBROUTINE HashInsert
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global HashInsert
                       

			HashInsert:
/* 000000	 136 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i0,%g0

!  137		      !   /* search for existing entry with this key */
!  138		      !   GLuint pos;
!  139		      !   struct HashEntry *entry;
!  141		      !   assert(table);

/* 0x0008	 141 */		be,pn	%icc,.L77000546
/* 0x000c	 142 */		cmp	%i1,0

! Registers live out of HashInsert: 
! o0 o2 sp i0 i1 i2 fp i7 gsr 
! 
		
!  142		      !   assert(key);

                       
! predecessor blocks: .L77000546 HashInsert

			.L900000412:
/* 0x0010	 142 */		be,pn	%icc,.L77000554
/* 0x0014	     */		nop

! Registers live out of .L900000412: 
! o0 o2 sp i0 i1 i2 fp i7 gsr 
! 
		
!  144		      !   if (key > table->MaxKey)

                       
! predecessor blocks: .L900000412

			.L77000560:
/* 0x0018	 144 */		ld	[%i0+4004],%g3

! Registers live out of .L77000560: 
! g3 o0 sp i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000554 .L77000560

			.L900000411:
/* 0x001c	 144 */		cmp	%i1,%g3
/* 0x0020	     */		bleu,pn	%icc,.L77000564
/* 0x0024	 148 */		sethi	%hi(0x5e1d000),%o7

! Registers live out of .L900000411: 
! o0 sp o7 i0 i1 i2 fp i7 gsr 
! 
		
!  145		      !      table->MaxKey = key;

                       
! predecessor blocks: .L900000411

			.L77000562:
/* 0x0028	 145 */		st	%i1,[%i0+4004]

! Registers live out of .L77000562: 
! o0 sp o7 i0 i1 i2 fp i7 gsr 
! 
		
!  147		      !   pos = key % TABLE_SIZE;
!  148		      !   entry = table->Table[pos];

                       
! predecessor blocks: .L77000562 .L900000411

			.L77000564:
/* 0x002c	 148 */		add	%o7,635,%o5
/* 0x0030	     */		srl	%i1,0,%o4
/* 0x0034	     */		mulx	%o4,%o5,%o3
/* 0x0038	     */		srlx	%o3,32,%i4
/* 0x003c	     */		sub	%i1,%i4,%i5
/* 0x0040	     */		srl	%i5,1,%l7
/* 0x0044	     */		add	%i4,%l7,%l6
/* 0x0048	     */		srl	%l6,4,%l5
/* 0x004c	     */		srl	%l6,9,%o2
/* 0x0050	     */		and	%l5,-32,%l4
/* 0x0054	     */		sub	%l4,%o2,%l3
/* 0x0058	     */		sll	%l3,2,%l2
/* 0x005c	     */		add	%o2,%l2,%l1
/* 0x0060	     */		sll	%l1,3,%l0
/* 0x0064	     */		add	%o2,%l0,%o1
/* 0x0068	     */		sub	%i1,%o1,%g5
/* 0x006c	     */		sll	%g5,2,%i4
/* 0x0070	     */		ld	[%i0+%i4],%g4

!  149		      !   while (entry) {

/* 0x0074	 149 */		cmp	%g4,0
/* 0x0078	     */		be,pn	%icc,.L900000413

!  150		      !      if (entry->Key == key) {
!  151		      !         /* replace entry's data */
!  152		      !	 entry->Data = data;
!  153		      !	 return;
!  154		      !      }
!  155		      !      entry = entry->Next;
!  156		      !   }
!  158		      !   /* alloc and insert new table entry */
!  159		      !   entry = (struct HashEntry *) calloc(sizeof(struct HashEntry), 1);

/* 0x007c	 159 */		or	%g0,1,%o1

! Registers live out of .L77000564: 
! g4 o0 o1 sp i0 i1 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000564

			.L77000568:
/* 0x0080	 150 */		ld	[%g4],%i3

! Registers live out of .L77000568: 
! g4 o0 sp i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000568 .L77000572

			.L900000414:
/* 0x0084	 150 */		cmp	%i3,%i1
/* 0x0088	     */		be,a,pn	%icc,.L77000577
/* 0x008c	 152 */		st	%i2,[%g4+4]

! Registers live out of .L900000414: 
! g4 o0 sp i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000414

			.L77000572:
/* 0x0090	 155 */		ld	[%g4+8],%g4
/* 0x0094	 149 */		cmp	%g4,0
/* 0x0098	     */		bne,a,pt	%icc,.L900000414
/* 0x009c	 150 */		ld	[%g4],%i3

! Registers live out of .L77000572: 
! g4 o0 sp i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000572

			.L77000576:
/* 0x00a0	 159 */		or	%g0,1,%o1

! Registers live out of .L77000576: 
! o0 o1 sp i0 i1 i2 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000564 .L77000576

			.L900000413:
/* 0x00a4	 159 */		call	calloc	! params =  %o0 %o1	! Result =  %o0
/* 0x00a8	     */		or	%g0,12,%o0

!  160		      !   entry->Key = key;

/* 0x00ac	 160 */		st	%i1,[%o0]

!  161		      !   entry->Data = data;

/* 0x00b0	 161 */		st	%i2,[%o0+4]

!  162		      !   entry->Next = table->Table[pos];

/* 0x00b4	 162 */		ld	[%i0+%i4],%i5
/* 0x00b8	     */		st	%i5,[%o0+8]

!  163		      !   table->Table[pos] = entry;

/* 0x00bc	 163 */		st	%o0,[%i0+%i4]

! Registers live out of .L900000413: 
! sp fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000413 .L900000414

			.L77000577:
/* 0x00c0	 163 */		ret	! Result = 
/* 0x00c4	     */		restore	%g0,0,%g0
                       
! predecessor blocks: HashInsert

			.L77000546:
/* 0x00c8	 141 */		sethi	%hi(.L70),%o0
/* 0x00cc	     */		add	%o0,%lo(.L70),%o1
/* 0x00d0	     */		sethi	%hi(.L69),%i3
/* 0x00d4	     */		add	%i3,%lo(.L69),%o0
/* 0x00d8	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x00dc	     */		or	%g0,141,%o2
/* 0x00e0	     */		ba	.L900000412
/* 0x00e4	 142 */		cmp	%i1,0

! Registers live out of .L77000546: 
! o0 o2 sp i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000412

			.L77000554:
/* 0x00e8	 142 */		sethi	%hi(.L76),%g2
/* 0x00ec	     */		sethi	%hi(.L75),%g1
/* 0x00f0	     */		add	%g2,%lo(.L76),%o1
/* 0x00f4	     */		add	%g1,%lo(.L75),%o0
/* 0x00f8	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x00fc	     */		or	%g0,142,%o2
/* 0x0100	     */		ba	.L900000411
/* 0x0104	 144 */		ld	[%i0+4004],%g3

! Registers live out of .L77000554: 
! g3 o0 sp i0 i1 i2 fp i7 gsr 
! 
		/* 0x0108	   0 */		.type	HashInsert,2
/* 0x0108	   0 */		.size	HashInsert,(.-HashInsert)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!  164		      !}
!  168		      !/*
!  169		      ! * Remove an entry from the hash table.
!  170		      ! * Input:  table - the hash table
!  171		      ! *         key - key of entry to remove
!  172		      ! */
!  173		      !void HashRemove(struct HashTable *table, GLuint key)
!  174		      !{

!
! SUBROUTINE HashRemove
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global HashRemove
                       

			HashRemove:
/* 000000	 174 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i0,%g0

!  175		      !   GLuint pos;
!  176		      !   struct HashEntry *entry, *prev;
!  178		      !   assert(table);

/* 0x0008	 178 */		be,pn	%icc,.L77000599
/* 0x000c	 179 */		cmp	%i1,0

! Registers live out of HashRemove: 
! o2 sp i0 i1 i3 fp i7 gsr 
! 
		
!  179		      !   assert(key);

                       
! predecessor blocks: .L77000599 HashRemove

			.L900000510:
/* 0x0010	 179 */		be,pn	%icc,.L77000607
/* 0x0014	 183 */		sethi	%hi(0x5e1d000),%o7

! Registers live out of .L900000510: 
! o2 sp o7 i0 i1 fp i7 gsr 
! 
		
!  181		      !   pos = key % TABLE_SIZE;
!  182		      !   prev = NULL;
!  183		      !   entry = table->Table[pos];

                       
! predecessor blocks: .L77000607 .L900000510

			.L900000509:
/* 0x0018	 183 */		add	%o7,635,%o5
/* 0x001c	     */		srl	%i1,0,%o4
/* 0x0020	     */		mulx	%o4,%o5,%o3
/* 0x0024	     */		srlx	%o3,32,%l7
/* 0x0028	     */		sub	%i1,%l7,%i5
/* 0x002c	     */		srl	%i5,1,%l6
/* 0x0030	     */		add	%l7,%l6,%l5
/* 0x0034	     */		srl	%l5,4,%l4
/* 0x0038	     */		srl	%l5,9,%o1
/* 0x003c	     */		and	%l4,-32,%l3
/* 0x0040	     */		sub	%l3,%o1,%l2
/* 0x0044	     */		sll	%l2,2,%l1
/* 0x0048	     */		add	%o1,%l1,%l0
/* 0x004c	     */		sll	%l0,3,%o2
/* 0x0050	     */		add	%o1,%o2,%o0
/* 0x0054	     */		sub	%i1,%o0,%g5
/* 0x0058	     */		sll	%g5,2,%g4
/* 0x005c	     */		ld	[%i0+%g4],%g3

!  184		      !   while (entry) {

/* 0x0060	 184 */		cmp	%g3,0
/* 0x0064	     */		be,pn	%icc,.L77000632
/* 0x0068	 182 */		or	%g0,0,%i3

! Registers live out of .L900000509: 
! g3 g4 sp i0 i1 i3 fp i7 gsr 
! 
		
!  185		      !      if (entry->Key == key) {

                       
! predecessor blocks: .L900000509

			.L77000617:
/* 0x006c	 185 */		ld	[%g3],%i2

! Registers live out of .L77000617: 
! g3 g4 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000617 .L77000627

			.L900000512:
/* 0x0070	 185 */		cmp	%i2,%i1
/* 0x0074	     */		be,pn	%icc,.L900000513
/* 0x0078	 187 */		cmp	%i3,0

! Registers live out of .L900000512: 
! g3 g4 sp i0 i1 i2 i3 fp i7 gsr 
! 
		
!  186		      !         /* found it! */
!  187		      !         if (prev) {
!  188		      !            prev->Next = entry->Next;
!  189		      !         }
!  190		      !         else {
!  191		      !            table->Table[pos] = entry->Next;
!  192		      !         }
!  193		      !         free(entry);
!  194		      !	 return;
!  195		      !      }
!  196		      !      prev = entry;

                       
! predecessor blocks: .L900000512

			.L77000627:
/* 0x007c	 196 */		or	%g0,%g3,%i3

!  197		      !      entry = entry->Next;

/* 0x0080	 197 */		ld	[%g3+8],%g3
/* 0x0084	 184 */		cmp	%g3,0
/* 0x0088	     */		bne,a,pt	%icc,.L900000512
/* 0x008c	 185 */		ld	[%g3],%i2

! Registers live out of .L77000627: 
! g3 g4 sp i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000627

			.L900000508:
/* 0x0090	 184 */		ret	! Result = 
/* 0x0094	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000512

			.L900000513:
/* 0x0098	 187 */		be,a,pn	%icc,.L900000511
/* 0x009c	 191 */		ld	[%g3+8],%i3

! Registers live out of .L900000513: 
! g3 g4 sp i0 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000513

			.L77000621:
/* 0x00a0	 188 */		ld	[%g3+8],%i4
/* 0x00a4	 193 */		or	%g0,%g3,%i0
/* 0x00a8	 188 */		st	%i4,[%i3+8]
/* 0x00ac	 193 */		call	free	! params =  %i0	! Result = 	! (tail call)
/* 0x00b0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000513

			.L900000511:
/* 0x00b4	 191 */		st	%i3,[%i0+%g4]
/* 0x00b8	 193 */		or	%g0,%g3,%i0
/* 0x00bc	     */		call	free	! params =  %i0	! Result = 	! (tail call)
/* 0x00c0	     */		restore	%g0,0,%g0
                       
! predecessor blocks: .L900000509

			.L77000632:
/* 0x00c4	 184 */		ret	! Result = 
/* 0x00c8	     */		restore	%g0,0,%g0
                       
! predecessor blocks: HashRemove

			.L77000599:
/* 0x00cc	 178 */		sethi	%hi(.L96),%i4
/* 0x00d0	     */		sethi	%hi(.L95),%i2
/* 0x00d4	     */		add	%i4,%lo(.L96),%o1
/* 0x00d8	     */		add	%i2,%lo(.L95),%o0
/* 0x00dc	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x00e0	     */		or	%g0,178,%o2
/* 0x00e4	     */		ba	.L900000510
/* 0x00e8	 179 */		cmp	%i1,0

! Registers live out of .L77000599: 
! o2 sp i0 i1 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000510

			.L77000607:
/* 0x00ec	 179 */		sethi	%hi(.L102),%g2
/* 0x00f0	     */		sethi	%hi(.L101),%g1
/* 0x00f4	     */		add	%g2,%lo(.L102),%o1
/* 0x00f8	     */		add	%g1,%lo(.L101),%o0
/* 0x00fc	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x0100	     */		or	%g0,179,%o2
/* 0x0104	     */		ba	.L900000509
/* 0x0108	 183 */		sethi	%hi(0x5e1d000),%o7

! Registers live out of .L77000607: 
! sp o7 i0 i1 fp i7 gsr 
! 
		/* 0x010c	   0 */		.type	HashRemove,2
/* 0x010c	   0 */		.size	HashRemove,(.-HashRemove)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!  198		      !   }
!  199		      !}
!  203		      !/*
!  204		      ! * Return the key of the "first" entry in the hash table.
!  205		      ! * By calling this function until zero is returned we can get
!  206		      ! * the keys of all entries in the table.
!  207		      ! */
!  208		      !GLuint HashFirstEntry(const struct HashTable *table)
!  209		      !{

!
! SUBROUTINE HashFirstEntry
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global HashFirstEntry
                       

			HashFirstEntry:
/* 000000	 209 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i0,%i0

!  210		      !   GLuint pos;
!  211		      !   assert(table);

/* 0x0008	 211 */		be,pn	%icc,.L77000651

!  212		      !   for (pos=0; pos < TABLE_SIZE; pos++) {

/* 0x000c	 212 */		or	%g0,0,%i3

! Registers live out of HashFirstEntry: 
! o2 sp i0 i3 fp i7 gsr 
! 
		
!  213		      !      if (table->Table[pos])

                       
! predecessor blocks: .L77000651 HashFirstEntry

			.L77000661:
/* 0x0010	 213 */		sll	%i3,2,%i5

! Registers live out of .L77000661: 
! sp i0 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000661 .L77000665

			.L900000605:
/* 0x0014	 213 */		ld	[%i5+%i0],%i4
/* 0x0018	     */		cmp	%i4,0
/* 0x001c	     */		bne,pn	%icc,.L77000663
/* 0x0020	 212 */		add	%i3,1,%i3

! Registers live out of .L900000605: 
! sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000605

			.L77000665:
/* 0x0024	 212 */		cmp	%i3,1001
/* 0x0028	     */		bcs,pt	%icc,.L900000605
/* 0x002c	 213 */		sll	%i3,2,%i5

! Registers live out of .L77000665: 
! sp i0 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000665

			.L77000669:
/* 0x0030	 216 */		ret	! Result =  %i0
/* 0x0034	     */		restore	%g0,0,%o0

!  214		      !         return table->Table[pos]->Key;

                       
! predecessor blocks: .L900000605

			.L77000663:
/* 0x0038	 214 */		ld	[%i4],%i0
/* 0x003c	 216 */		ret	! Result =  %i0
/* 0x0040	     */		restore	%g0,0,%g0
                       
! predecessor blocks: HashFirstEntry

			.L77000651:
/* 0x0044	 211 */		sethi	%hi(.L123),%i1
/* 0x0048	     */		sethi	%hi(.L122),%i2
/* 0x004c	     */		add	%i1,%lo(.L123),%o1
/* 0x0050	     */		add	%i2,%lo(.L122),%o0
/* 0x0054	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x0058	     */		or	%g0,211,%o2
/* 0x005c	     */		ba	.L77000661
/* 0x0060	 212 */		or	%g0,0,%i3

! Registers live out of .L77000651: 
! sp i0 i3 fp i7 gsr 
! 
		/* 0x0064	   0 */		.type	HashFirstEntry,2
/* 0x0064	   0 */		.size	HashFirstEntry,(.-HashFirstEntry)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4
/* 000000	     */		.skip	16
/* 0x0010	     */		.align	4

!  215		      !   }
!  216		      !   return 0;
!  217		      !}
!  221		      !/*
!  222		      ! * Dump contents of hash table for debugging.
!  223		      ! */
!  224		      !void HashPrint(const struct HashTable *table)
!  225		      !{

!
! SUBROUTINE HashPrint
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global HashPrint
                       

			HashPrint:
/* 000000	 225 */		save	%sp,-96,%sp
/* 0x0004	     */		orcc	%g0,%i0,%i0

!  226		      !   GLuint i;
!  227		      !   assert(table);

/* 0x0008	 227 */		be,pn	%icc,.L77000685

!  228		      !   for (i=0;i<TABLE_SIZE;i++) {

/* 0x000c	 228 */		or	%g0,0,%i3

! Registers live out of HashPrint: 
! o2 sp i0 i3 fp i7 gsr 
! 
		
!  229		      !      struct HashEntry *entry = table->Table[i];
!  230		      !      while (entry) {
!  231		      !	 printf("%u %p\n", entry->Key, entry->Data);

                       
! predecessor blocks: HashPrint

			.L77000691:
/* 0x0010	 231 */		sethi	%hi(.L151),%i4

! Registers live out of .L77000691: 
! o2 sp i0 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000685 .L77000691

			.L900000706:
/* 0x0014	 231 */		add	%i4,%lo(.L151),%i2
/* 0x0018	 229 */		sll	%i3,2,%i5

! Registers live out of .L900000706: 
! o2 sp i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000703 .L900000706

			.L900000707:
/* 0x001c	 229 */		ld	[%i5+%i0],%i5
/* 0x0020	 230 */		cmp	%i5,0
/* 0x0024	     */		be,pn	%icc,.L77000703
/* 0x0028	 231 */		or	%g0,%i2,%o0

! Registers live out of .L900000707: 
! o0 o2 sp i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000707 .L900000708

			.L900000708:
/* 0x002c	 231 */		ld	[%i5],%o1
/* 0x0030	     */		call	printf	! params =  %o0 %o1 %o2	! Result = 
/* 0x0034	     */		ld	[%i5+4],%o2

!  232		      !	 entry = entry->Next;

/* 0x0038	 232 */		ld	[%i5+8],%i5
/* 0x003c	 230 */		cmp	%i5,0
/* 0x0040	     */		bne,pt	%icc,.L900000708
/* 0x0044	 231 */		or	%g0,%i2,%o0

! Registers live out of .L900000708: 
! o0 o2 sp i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000707 .L900000708

			.L77000703:
/* 0x0048	 228 */		add	%i3,1,%i3
/* 0x004c	     */		cmp	%i3,1001
/* 0x0050	     */		bcs,pt	%icc,.L900000707
/* 0x0054	 229 */		sll	%i3,2,%i5

! Registers live out of .L77000703: 
! o2 sp i0 i2 i3 i5 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000703

			.L77000708:
/* 0x0058	 228 */		ret	! Result = 
/* 0x005c	     */		restore	%g0,0,%g0
                       
! predecessor blocks: HashPrint

			.L77000685:
/* 0x0060	 227 */		sethi	%hi(.L141),%i1
/* 0x0064	     */		sethi	%hi(.L140),%l7
/* 0x0068	     */		add	%i1,%lo(.L141),%o1
/* 0x006c	     */		add	%l7,%lo(.L140),%o0
/* 0x0070	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x0074	     */		or	%g0,227,%o2
/* 0x0078	     */		ba	.L900000706
/* 0x007c	 231 */		sethi	%hi(.L151),%i4

! Registers live out of .L77000685: 
! o2 sp i0 i3 i4 fp i7 gsr 
! 
		/* 0x0080	   0 */		.type	HashPrint,2
/* 0x0080	   0 */		.size	HashPrint,(.-HashPrint)

	.section	".text",#alloc,#execinstr,#progbits
/* 000000	   0 */		.align	4

!  233		      !      }
!  234		      !   }
!  235		      !}
!  239		      !/*
!  240		      ! * Find a block of 'numKeys' adjacent unused hash keys.
!  241		      ! * Input:  table - the hash table
!  242		      ! *         numKeys - number of keys needed
!  243		      ! * Return:  startint key of free block or 0 if failure
!  244		      ! */
!  245		      !GLuint HashFindFreeKeyBlock(const struct HashTable *table, GLuint numKeys)
!  246		      !{

!
! SUBROUTINE HashFindFreeKeyBlock
!
! OFFSET    SOURCE LINE	LABEL	INSTRUCTION

                       	.global HashFindFreeKeyBlock
                       

			HashFindFreeKeyBlock:
/* 000000	 246 */		save	%sp,-104,%sp

!  247		      !   GLuint maxKey = ~0;
!  248		      !   if (maxKey - numKeys > table->MaxKey) {

/* 0x0004	 248 */		or	%g0,-1,%i5
/* 0x0008	     */		ld	[%i0+4004],%i2
/* 0x000c	     */		sub	%i5,%i1,%i4
/* 0x0010	     */		cmp	%i4,%i2
/* 0x0014	     */		bleu,pn	%icc,.L77000736
/* 0x0018	 250 */		add	%i2,1,%i2

! Registers live out of HashFindFreeKeyBlock: 
! o2 sp l7 i0 i1 i2 fp i7 gsr 
! 
		                       
! predecessor blocks: HashFindFreeKeyBlock

			.L77000734:
/* 0x001c	 272 */		ret	! Result =  %i0
/* 0x0020	     */		restore	%i2,0,%o0

!  249		      !      /* the quick solution */
!  250		      !      return table->MaxKey + 1;
!  251		      !   }
!  252		      !   else {
!  253		      !      /* the slow solution */
!  254		      !      GLuint freeCount = 0;

                       
! predecessor blocks: HashFindFreeKeyBlock

			.L77000736:
/* 0x0024	 254 */		or	%g0,0,%l2

!  255		      !      GLuint freeStart = 0;

/* 0x0028	 255 */		or	%g0,0,%i2

!  256		      !      GLuint key;
!  257		      !      for (key=0; key!=maxKey; key++) {

/* 0x002c	 257 */		or	%g0,0,%i3
/* 0x0030	 116 */		sethi	%hi(0x5e1d000),%o3
/* 0x0034	 113 */		cmp	%g0,0

! Registers live out of .L77000736: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000736 .L900000810

			.L900000809:
/* 0x0038	 113 */		be,pn	%icc,.L77000769
/* 0x003c	 116 */		srl	%i3,0,%o5

! Registers live out of .L900000809: 
! o2 o3 o5 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000769 .L900000809

			.L900000808:
/* 0x0040	 116 */		add	%o3,635,%o7
/* 0x0044	     */		mulx	%o5,%o7,%o4
/* 0x0048	     */		srlx	%o4,32,%l4
/* 0x004c	     */		sub	%i3,%l4,%l5
/* 0x0050	     */		srl	%l5,1,%l3
/* 0x0054	     */		add	%l4,%l3,%l1
/* 0x0058	     */		srl	%l1,4,%l0
/* 0x005c	     */		srl	%l1,9,%g3
/* 0x0060	     */		and	%l0,-32,%o2
/* 0x0064	     */		sub	%o2,%g3,%o1
/* 0x0068	     */		sll	%o1,2,%o0
/* 0x006c	     */		add	%g3,%o0,%g5
/* 0x0070	     */		sll	%g5,3,%g4
/* 0x0074	     */		add	%g3,%g4,%g2
/* 0x0078	     */		sub	%i3,%g2,%g1
/* 0x007c	     */		sll	%g1,2,%i5
/* 0x0080	     */		ld	[%i5+%i0],%i4
/* 0x0084	 117 */		cmp	%i4,0
/* 0x0088	     */		be,a,pn	%icc,.L900000811
/* 0x008c	 265 */		add	%l2,1,%l2

! Registers live out of .L900000808: 
! o2 o3 o5 sp l2 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000808

			.L77000779:
/* 0x0090	 118 */		ld	[%i4],%l6

! Registers live out of .L77000779: 
! o2 o3 o5 sp l2 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000779 .L77000783

			.L900000812:
/* 0x0094	 118 */		cmp	%l6,%i3
/* 0x0098	     */		be,a,pn	%icc,.L900000813
/* 0x009c	 258 */		ld	[%i4+4],%l7

! Registers live out of .L900000812: 
! o2 o3 o5 sp l2 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000812

			.L77000783:
/* 0x00a0	 121 */		ld	[%i4+8],%i4
/* 0x00a4	 117 */		cmp	%i4,0
/* 0x00a8	     */		bne,a,pt	%icc,.L900000812
/* 0x00ac	 118 */		ld	[%i4],%l6

! Registers live out of .L77000783: 
! o2 o3 o5 sp l2 l6 l7 i0 i1 i2 i3 i4 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000783

			.L900000807:
/* 0x00b0	 117 */		ba	.L900000811
/* 0x00b4	 265 */		add	%l2,1,%l2

! Registers live out of .L900000807: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  258		      !	 if (HashLookup(table, key)) {

                       
! predecessor blocks: .L900000812

			.L900000813:
/* 0x00b8	 258 */		cmp	%l7,0
/* 0x00bc	     */		be,pn	%icc,.L900000811
/* 0x00c0	 265 */		add	%l2,1,%l2

! Registers live out of .L900000813: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  259		      !	    /* darn, this key is already in use */
!  260		      !	    freeCount = 0;
!  261		      !	    freeStart = key+1;

                       
! predecessor blocks: .L900000813

			.L77000742:
/* 0x00c4	 261 */		add	%i3,1,%i3
/* 0x00c8	 260 */		or	%g0,0,%l2
/* 0x00cc	 261 */		or	%g0,%i3,%i2
/* 0x00d0	     */		ba	.L900000810
/* 0x00d4	 257 */		cmp	%i3,-1

! Registers live out of .L77000742: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  262		      !	 }
!  263		      !	 else {
!  264		      !	    /* this key not in use, check if we've found enough */
!  265		      !	    freeCount++;
!  266		      !	    if (freeCount == numKeys) {

                       
! predecessor blocks: .L900000807 .L900000808 .L900000813

			.L900000811:
/* 0x00d8	 266 */		cmp	%l2,%i1
/* 0x00dc	     */		be,pn	%icc,.L77000755
/* 0x00e0	     */		add	%i3,1,%i3

! Registers live out of .L900000811: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L900000811

			.L77000750:
/* 0x00e4	 257 */		cmp	%i3,-1

! Registers live out of .L77000750: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		                       
! predecessor blocks: .L77000742 .L77000750

			.L900000810:
/* 0x00e8	 257 */		bne,pt	%icc,.L900000809
/* 0x00ec	 113 */		cmp	%i3,0

! Registers live out of .L900000810: 
! o2 o3 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		
!  267		      !	       return freeStart;
!  268		      !	    }
!  269		      !	 }
!  270		      !      }
!  271		      !      /* cannot allocate a block of numKeys consecutive keys */
!  272		      !      return 0;

                       
! predecessor blocks: .L900000810

			.L77000754:
/* 0x00f0	 272 */		or	%g0,0,%i2
/* 0x00f4	     */		ret	! Result =  %i0
/* 0x00f8	     */		restore	%i2,0,%o0
                       
! predecessor blocks: .L900000811

			.L77000755:
/* 0x00fc	 272 */		ret	! Result =  %i0
/* 0x0100	     */		restore	%i2,0,%o0
                       
! predecessor blocks: .L900000809

			.L77000769:
/* 0x0104	 113 */		sethi	%hi(.L52),%l7
/* 0x0108	     */		sethi	%hi(.L51),%l6
/* 0x010c	     */		add	%l7,%lo(.L52),%o1
/* 0x0110	     */		add	%l6,%lo(.L51),%o0
/* 0x0114	     */		stx	%o3,[%sp+96]
/* 0x0118	     */		call	__assert	! params =  %o0 %o1 %o2	! Result = 
/* 0x011c	     */		or	%g0,113,%o2
/* 0x0120	     */		ldx	[%sp+96],%o3
/* 0x0124	     */		ba	.L900000808
/* 0x0128	 116 */		srl	%i3,0,%o5

! Registers live out of .L77000769: 
! o3 o5 sp l2 l7 i0 i1 i2 i3 fp i7 gsr 
! 
		/* 0x012c	   0 */		.type	HashFindFreeKeyBlock,2
/* 0x012c	   0 */		.size	HashFindFreeKeyBlock,(.-HashFindFreeKeyBlock)

	.section	".compcom"
/* 000000	   0 */		.align	8
/* 000000	   0 */		.word	0
/* 0x0004	   0 */		.word	1
/* 0x0008	   0 */		.word	16
/* 0x000c	   0 */		.word	20
/* 0x0010	   0 */		.word	14
/* 0x0014	   0 */		.word	61
/* 0x0018	   0 */		.align	4
/* 0x0018	   0 */		.word	-1
/* 0x001c	   0 */		.word	-1
/* 0x0020	   0 */		.word	76
/* 0x0024	   0 */		.word	131075
/* 0x0028	   0 */		.word	1
/* 0x002c	   0 */		.word	0
/* 0x0030	   0 */		.align	4
/* 0x0030	   0 */		.word	-1
/* 0x0034	   0 */		.word	-1
/* 0x0038	   0 */		.word	88
/* 0x003c	   0 */		.word	65571
/* 0x0040	   0 */		.word	1
/* 0x0044	   0 */		.word	1
/* 0x0048	   0 */		.align	4
/* 0x0048	   0 */		.word	-1
/* 0x004c	   0 */		.word	-1
/* 0x0050	   0 */		.word	90
/* 0x0054	   0 */		.word	65572
/* 0x0058	   0 */		.word	1
/* 0x005c	   0 */		.word	2
/* 0x0060	   0 */		.align	4
/* 0x0060	   0 */		.word	-1
/* 0x0064	   0 */		.word	-1
/* 0x0068	   0 */		.word	96
/* 0x006c	   0 */		.word	131075
/* 0x0070	   0 */		.word	1
/* 0x0074	   0 */		.word	3
/* 0x0078	   0 */		.align	4
/* 0x0078	   0 */		.word	-1
/* 0x007c	   0 */		.word	-1
/* 0x0080	   0 */		.word	90
/* 0x0084	   0 */		.word	8219
/* 0x0088	   0 */		.word	1
/* 0x008c	   0 */		.word	4
/* 0x0090	   0 */		.align	4
/* 0x0090	   0 */		.word	-1
/* 0x0094	   0 */		.word	-1
/* 0x0098	   0 */		.word	117
/* 0x009c	   0 */		.word	65572
/* 0x00a0	   0 */		.word	1
/* 0x00a4	   0 */		.word	5
/* 0x00a8	   0 */		.align	4
/* 0x00a8	   0 */		.word	-1
/* 0x00ac	   0 */		.word	-1
/* 0x00b0	   0 */		.word	149
/* 0x00b4	   0 */		.word	65572
/* 0x00b8	   0 */		.word	1
/* 0x00bc	   0 */		.word	6
/* 0x00c0	   0 */		.align	4
/* 0x00c0	   0 */		.word	-1
/* 0x00c4	   0 */		.word	-1
/* 0x00c8	   0 */		.word	184
/* 0x00cc	   0 */		.word	65572
/* 0x00d0	   0 */		.word	1
/* 0x00d4	   0 */		.word	7
/* 0x00d8	   0 */		.align	4
/* 0x00d8	   0 */		.word	-1
/* 0x00dc	   0 */		.word	-1
/* 0x00e0	   0 */		.word	193
/* 0x00e4	   0 */		.word	131075
/* 0x00e8	   0 */		.word	1
/* 0x00ec	   0 */		.word	8
/* 0x00f0	   0 */		.align	4
/* 0x00f0	   0 */		.word	-1
/* 0x00f4	   0 */		.word	-1
/* 0x00f8	   0 */		.word	212
/* 0x00fc	   0 */		.word	65571
/* 0x0100	   0 */		.word	1
/* 0x0104	   0 */		.word	9
/* 0x0108	   0 */		.align	4
/* 0x0108	   0 */		.word	-1
/* 0x010c	   0 */		.word	-1
/* 0x0110	   0 */		.word	228
/* 0x0114	   0 */		.word	65571
/* 0x0118	   0 */		.word	1
/* 0x011c	   0 */		.word	10
/* 0x0120	   0 */		.align	4
/* 0x0120	   0 */		.word	-1
/* 0x0124	   0 */		.word	-1
/* 0x0128	   0 */		.word	230
/* 0x012c	   0 */		.word	65572
/* 0x0130	   0 */		.word	1
/* 0x0134	   0 */		.word	11
/* 0x0138	   0 */		.align	4
/* 0x0138	   0 */		.word	-1
/* 0x013c	   0 */		.word	-1
/* 0x0140	   0 */		.word	230
/* 0x0144	   0 */		.word	8219
/* 0x0148	   0 */		.word	1
/* 0x014c	   0 */		.word	12
/* 0x0150	   0 */		.align	4
/* 0x0150	   0 */		.word	-1
/* 0x0154	   0 */		.word	-1
/* 0x0158	   0 */		.word	258
/* 0x015c	   0 */		.word	16409
/* 0x0160	   0 */		.word	3
/* 0x0164	   0 */		.word	13
/* 0x0168	   0 */		.align	4
/* 0x0168	   0 */		.word	-1
/* 0x016c	   0 */		.word	-1
/* 0x0170	   0 */		.word	258
/* 0x0174	   0 */		.word	16411
/* 0x0178	   0 */		.word	3
/* 0x017c	   0 */		.word	16
/* 0x0180	   0 */		.align	4
/* 0x0180	   0 */		.word	-1
/* 0x0184	   0 */		.word	-1
/* 0x0188	   0 */		.word	257
/* 0x018c	   0 */		.word	65571
/* 0x0190	   0 */		.word	1
/* 0x0194	   0 */		.word	19
/* 0x0198	   0 */		.word	7
/* 0x019c	   0 */		.word	14
/* 0x01a0	   0 */		.word	17
/* 0x01a4	   0 */		.word	20
/* 0x01a8	   0 */		.word	17
/* 0x01ac	   0 */		.word	25
/* 0x01b0	   0 */		.word	28
/* 0x01b4	   0 */		.word	31
/* 0x01b8	   0 */		.word	20
/* 0x01bc	   0 */		.word	34
/* 0x01c0	   0 */		.word	37
/* 0x01c4	   0 */		.word	40
/* 0x01c8	   0 */		.word	40
/* 0x01cc	   0 */		.word	43
/* 0x01d0	   0 */		.word	0
/* 0x01d4	   0 */		.word	1
/* 0x01d8	   0 */		.word	43
/* 0x01dc	   0 */		.word	117
/* 0x01e0	   0 */		.word	54
/* 0x01e4	   0 */		.word	58
/* 0x01e8	   0 */		.asciz	"hash.c"
/* 0x01ef	   0 */		.asciz	"calloc"
/* 0x01f6	   0 */		.asciz	"L1"
/* 0x01f9	   0 */		.asciz	"L5"
/* 0x01fc	   0 */		.asciz	"free"
/* 0x0201	   0 */		.asciz	"L6"
/* 0x0204	   0 */		.asciz	"L7"
/* 0x0207	   0 */		.asciz	"L8"
/* 0x020a	   0 */		.asciz	"L2"
/* 0x020d	   0 */		.asciz	"L3"
/* 0x0210	   0 */		.asciz	"L9"
/* 0x0213	   0 */		.asciz	"HashLookup"
/* 0x021e	   0 */		.asciz	"L10"
/* 0x0222	   0 */		.asciz	"L4"

! Begin Disassembling Debug Info
!  Begin sdCreateSection : .debug_loc
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_loc"
!  End sdCreateSection
!  Begin sdCreateSection : .debug_info
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_abbrev, lab2=, loff=0
!   reloc[1]: knd=2, off=248, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=270, siz=4, lab1=NewHashTable, lab2=, loff=0
!   reloc[3]: knd=0, off=274, siz=4, lab1=NewHashTable, lab2=, loff=20
!   reloc[4]: knd=0, off=485, siz=4, lab1=DeleteHashTable, lab2=, loff=0
!   reloc[5]: knd=0, off=489, siz=4, lab1=DeleteHashTable, lab2=, loff=112
!   reloc[6]: knd=0, off=580, siz=4, lab1=HashLookup, lab2=, loff=0
!   reloc[7]: knd=0, off=584, siz=4, lab1=HashLookup, lab2=, loff=216
!   reloc[8]: knd=0, off=692, siz=4, lab1=HashInsert, lab2=, loff=0
!   reloc[9]: knd=0, off=696, siz=4, lab1=HashInsert, lab2=, loff=264
!   reloc[10]: knd=0, off=806, siz=4, lab1=HashRemove, lab2=, loff=0
!   reloc[11]: knd=0, off=810, siz=4, lab1=HashRemove, lab2=, loff=268
!   reloc[12]: knd=0, off=925, siz=4, lab1=HashFirstEntry, lab2=, loff=0
!   reloc[13]: knd=0, off=929, siz=4, lab1=HashFirstEntry, lab2=, loff=100
!   reloc[14]: knd=0, off=1004, siz=4, lab1=HashPrint, lab2=, loff=0
!   reloc[15]: knd=0, off=1008, siz=4, lab1=HashPrint, lab2=, loff=128
!   reloc[16]: knd=0, off=1104, siz=4, lab1=HashFindFreeKeyBlock, lab2=, loff=0
!   reloc[17]: knd=0, off=1108, siz=4, lab1=HashFindFreeKeyBlock, lab2=, loff=300
	.section ".debug_info"
	.byte 0x00,0x00,0x05,0x7c,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "hash.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/pri/r/rsimtest/mesa/r5\0"
	.ascii " /local/SUNWspro/prod/bin/cc -fast -g -xtarget=ultraT2 -S  hash.c -W0,-xp\\$XAa59JCegJdLGZr.\0"
	.ascii "Xa;g;O;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCegJdLGZr.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "NewHashTable\0"
	.byte 0x01,0x02,0x01,0x4b
	.uaword NewHashTable
	.uaword NewHashTable+20
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0xcb,0x01
	.byte 0x03
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x04,0x00,0x00,0x01,0x1e
	.ascii "GLuint\0"
	.byte 0x02,0x03
	.ascii "void\0"
	.byte 0x05,0x00,0x05,0x00,0x00,0x01,0x37,0x05
	.byte 0x00,0x00,0x01,0x49,0x06
	.ascii "HashEntry\0"
	.byte 0x0c,0x00,0x00,0x01,0x80,0x07
	.ascii "Key\0"
	.byte 0x00,0x00,0x01,0x2a,0x02,0x23,0x00,0x07
	.ascii "Data\0"
	.byte 0x00,0x00,0x01,0x3f,0x02,0x23,0x04,0x07
	.ascii "Next\0"
	.byte 0x00,0x00,0x01,0x44,0x02,0x23,0x08,0x00
	.byte 0x03
	.ascii "long\0"
	.byte 0x05,0x04,0x08,0x00,0x00,0x01,0x44,0x0f
	.byte 0xa4,0x00,0x00,0x01,0x9b,0x09,0x00,0x00
	.byte 0x01,0x80,0x03,0xe8,0x00,0x0a
	.ascii "HashTable\0"
	.byte 0x0f,0xa8,0x00,0x00,0x01,0xcb,0x07
	.ascii "Table\0"
	.byte 0x00,0x00,0x01,0x88,0x02,0x23,0x00,0x07
	.ascii "MaxKey\0"
	.byte 0x00,0x00,0x01,0x2a,0x03,0x23,0xa4,0x1f
	.byte 0x00,0x05,0x00,0x00,0x01,0x9b,0x0b
	.ascii "DeleteHashTable\0"
	.byte 0x01,0x02,0x01,0x55
	.uaword DeleteHashTable
	.uaword DeleteHashTable+112
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x02,0x34
	.byte 0x0c,0x00,0x00,0x01,0xcb
	.ascii "table\0"
	.byte 0x01,0x54,0x01,0x68,0x0d
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0x56,0x01
	.byte 0x6c,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0x59,0x01
	.byte 0x6d,0x0d
	.ascii "next\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0x5b,0x01
	.byte 0x6d,0x0e,0x44,0x01,0x08,0x00,0x0f
	.ascii "HashLookup\0"
	.byte 0x01,0x02,0x01,0x6c
	.uaword HashLookup
	.uaword HashLookup+216
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x3f,0x01
	.byte 0x00,0x00,0x02,0x9a,0x0c,0x00,0x00,0x02
	.byte 0x9f
	.ascii "table\0"
	.byte 0x01,0x6b,0x01,0x68,0x0c,0x00,0x00,0x01
	.byte 0x2a
	.ascii "key\0"
	.byte 0x01,0x6b,0x03,0x91,0xc8,0x00,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0x6d,0x02
	.byte 0x91,0x78,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0x6e,0x01
	.byte 0x6c,0x0e,0x44,0x01,0x08,0x00,0x10,0x00
	.byte 0x00,0x01,0x9b,0x05,0x00,0x00,0x02,0x9a
	.byte 0x0b
	.ascii "HashInsert\0"
	.byte 0x01,0x02,0x01,0x88
	.uaword HashInsert
	.uaword HashInsert+264
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x03,0x16
	.byte 0x0c,0x00,0x00,0x01,0xcb
	.ascii "table\0"
	.byte 0x01,0x87,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2a
	.ascii "key\0"
	.byte 0x01,0x87,0x03,0x91,0xc8,0x00,0x0c,0x00
	.byte 0x00,0x01,0x3f
	.ascii "data\0"
	.byte 0x01,0x87,0x01,0x6a,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0x8a,0x02
	.byte 0x91,0x7c,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0x8b,0x01
	.byte 0x54,0x0e,0x44,0x01,0x08,0x00,0x0b
	.ascii "HashRemove\0"
	.byte 0x01,0x02,0x01,0xae
	.uaword HashRemove
	.uaword HashRemove+268
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x03,0x89
	.byte 0x0c,0x00,0x00,0x01,0xcb
	.ascii "table\0"
	.byte 0x01,0xad,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2a
	.ascii "key\0"
	.byte 0x01,0xad,0x03,0x91,0xc8,0x00,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0xaf,0x02
	.byte 0x91,0x7c,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0xb0,0x01
	.byte 0x53,0x0d
	.ascii "prev\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0xb0,0x01
	.byte 0x6b,0x0e,0x44,0x01,0x08,0x00,0x0f
	.ascii "HashFirstEntry\0"
	.byte 0x01,0x02,0x01,0xd1
	.uaword HashFirstEntry
	.uaword HashFirstEntry+100
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x2a,0x01
	.byte 0x00,0x00,0x03,0xd3,0x0c,0x00,0x00,0x03
	.byte 0xd8
	.ascii "table\0"
	.byte 0x01,0xd0,0x01,0x68,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0xd2,0x01
	.byte 0x6b,0x0e,0x44,0x01,0x08,0x00,0x10,0x00
	.byte 0x00,0x01,0x9b,0x05,0x00,0x00,0x03,0xd3
	.byte 0x0b
	.ascii "HashPrint\0"
	.byte 0x01,0x02,0x01,0xe1
	.uaword HashPrint
	.uaword HashPrint+128
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x04,0x2c
	.byte 0x0c,0x00,0x00,0x04,0x31
	.ascii "table\0"
	.byte 0x01,0xe0,0x01,0x68,0x0d
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0xe2,0x01
	.byte 0x6b,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x44,0x01,0x01,0xe5,0x01
	.byte 0x6d,0x0e,0x44,0x01,0x08,0x00,0x10,0x00
	.byte 0x00,0x01,0x9b,0x05,0x00,0x00,0x04,0x2c
	.byte 0x0f
	.ascii "HashFindFreeKeyBlock\0"
	.byte 0x01,0x02,0x01,0xf6
	.uaword HashFindFreeKeyBlock
	.uaword HashFindFreeKeyBlock+300
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x2a,0x01
	.byte 0x00,0x00,0x04,0xda,0x0c,0x00,0x00,0x04
	.byte 0xdf
	.ascii "table\0"
	.byte 0x01,0xf5,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2a
	.ascii "numKeys\0"
	.byte 0x01,0xf5,0x01,0x69,0x0d
	.ascii "maxKey\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0xf7,0x02
	.byte 0x91,0x78,0x0d
	.ascii "freeCount\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0xfe,0x01
	.byte 0x62,0x0d
	.ascii "freeStart\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0xff,0x01
	.byte 0x6a,0x11
	.ascii "key\0"
	.byte 0x00,0x00,0x01,0x2a,0x01,0x01,0x01,0x00
	.byte 0x01,0x6b,0x0e,0x42,0x03,0x94,0x02,0x0c
	.byte 0x0e,0x44,0x01,0x04,0x00,0x10,0x00,0x00
	.byte 0x01,0x9b,0x05,0x00,0x00,0x04,0xda,0x03
	.ascii "char\0"
	.byte 0x06,0x01,0x10,0x00,0x00,0x04,0xe4,0x05
	.byte 0x00,0x00,0x04,0xec,0x03
	.ascii "int\0"
	.byte 0x05,0x04,0x12
	.ascii "printf\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x04,0xf6,0x01
	.byte 0x00,0x00,0x05,0x18,0x13,0x00,0x00,0x04
	.byte 0xf1,0x14,0x00,0x15
	.ascii "free\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x05,0x2c
	.byte 0x13,0x00,0x00,0x01,0x3f,0x00,0x12
	.ascii "calloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x3f,0x01
	.byte 0x00,0x00,0x05,0x4b,0x13,0x00,0x00,0x01
	.byte 0x1e,0x13,0x00,0x00,0x01,0x1e,0x00,0x10
	.byte 0x00,0x00,0x04,0xe4,0x05,0x00,0x00,0x05
	.byte 0x4b,0x10,0x00,0x00,0x04,0xe4,0x05,0x00
	.byte 0x00,0x05,0x55,0x16
	.ascii "__assert\0"
	.byte 0x01,0x01,0x01,0x01,0x13,0x00,0x00,0x05
	.byte 0x50,0x13,0x00,0x00,0x05,0x5a,0x13,0x00
	.byte 0x00,0x04,0xf6,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=94, siz=4, lab1=NewHashTable, lab2=, loff=0
!   reloc[1]: knd=0, off=111, siz=4, lab1=DeleteHashTable, lab2=, loff=0
!   reloc[2]: knd=0, off=154, siz=4, lab1=HashLookup, lab2=, loff=0
!   reloc[3]: knd=0, off=214, siz=4, lab1=HashInsert, lab2=, loff=0
!   reloc[4]: knd=0, off=289, siz=4, lab1=HashRemove, lab2=, loff=0
!   reloc[5]: knd=0, off=391, siz=4, lab1=HashFirstEntry, lab2=, loff=0
!   reloc[6]: knd=0, off=431, siz=4, lab1=HashPrint, lab2=, loff=0
!   reloc[7]: knd=0, off=483, siz=4, lab1=HashFindFreeKeyBlock, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x02,0x69,0x00,0x02,0x00,0x00
	.byte 0x00,0x51,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x70,0x72,0x69
	.byte 0x2f,0x72,0x2f,0x72,0x73,0x69,0x6d,0x74
	.byte 0x65,0x73,0x74,0x2f,0x6d,0x65,0x73,0x61
	.byte 0x2f,0x72,0x35,0x00,0x47,0x4c,0x00,0x00
	.byte 0x68,0x61,0x73,0x68,0x2e,0x63,0x00,0x01
	.byte 0x00,0x00,0x67,0x6c,0x2e,0x68,0x00,0x02
	.byte 0x00,0x00,0x00,0x00,0x05,0x02
	.uaword NewHashTable
	.byte 0x06,0x03,0xcb,0x00,0x01,0x02,0x05,0x00
	.byte 0x01,0x01,0x00,0x05,0x02
	.uaword DeleteHashTable
	.byte 0x06,0x02,0x02,0x03,0xd6,0x00,0x01,0x10
	.byte 0x10,0x14,0x15,0x12,0x0e,0x15,0x02,0x01
	.byte 0x03,0x7c,0x01,0x18,0x02,0x01,0x03,0x07
	.byte 0x01,0x02,0x02,0x03,0x77,0x01,0x28,0x02
	.byte 0x01,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword HashLookup
	.byte 0x06,0x02,0x02,0x03,0xef,0x00,0x01,0x10
	.byte 0x02,0x02,0x03,0x03,0x01,0x58,0x02,0x02
	.byte 0x03,0x06,0x01,0x02,0x01,0x03,0x7b,0x01
	.byte 0x18,0x11,0x02,0x01,0x03,0x7c,0x01,0x14
	.byte 0x02,0x01,0x03,0x05,0x01,0x02,0x03,0x03
	.byte 0x75,0x01,0x28,0x02,0x08,0x03,0x03,0x01
	.byte 0x02,0x01,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword HashInsert
	.byte 0x06,0x02,0x02,0x03,0x8c,0x01,0x01,0x10
	.byte 0x19,0x02,0x03,0x03,0x04,0x01,0x02,0x01
	.byte 0x03,0x7d,0x01,0x02,0x01,0x03,0x03,0x01
	.byte 0x54,0x02,0x02,0x03,0x0a,0x01,0x02,0x01
	.byte 0x03,0x77,0x01,0x19,0x02,0x01,0x03,0x03
	.byte 0x01,0x02,0x01,0x03,0x7a,0x01,0x14,0x02
	.byte 0x01,0x03,0x09,0x01,0x18,0x10,0x10,0x14
	.byte 0x02,0x03,0x03,0x6a,0x01,0x28,0x2d,0x02
	.byte 0x01,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword HashRemove
	.byte 0x06,0x02,0x02,0x03,0xb1,0x01,0x01,0x10
	.byte 0x02,0x02,0x03,0x04,0x01,0x58,0x02,0x02
	.byte 0x03,0x7e,0x01,0x02,0x01,0x03,0x03,0x01
	.byte 0x19,0x02,0x01,0x03,0x09,0x01,0x10,0x02
	.byte 0x01,0x03,0x73,0x01,0x14,0x0e,0x02,0x02
	.byte 0x03,0x03,0x01,0x02,0x01,0x03,0x04,0x01
	.byte 0x02,0x01,0x03,0x7d,0x01,0x02,0x01,0x03
	.byte 0x05,0x01,0x02,0x01,0x03,0x7b,0x01,0x02
	.byte 0x01,0x03,0x05,0x01,0x02,0x02,0x03,0x7e
	.byte 0x01,0x11,0x02,0x03,0x03,0x77,0x01,0x02
	.byte 0x02,0x03,0x7a,0x01,0x28,0x02,0x08,0x03
	.byte 0x04,0x01,0x02,0x01,0x00,0x01,0x01,0x00
	.byte 0x05,0x02
	.uaword HashFirstEntry
	.byte 0x06,0x02,0x02,0x03,0xd2,0x01,0x01,0x10
	.byte 0x10,0x1a,0x18,0x02,0x01,0x03,0x03,0x01
	.byte 0x02,0x02,0x03,0x7e,0x01,0x11,0x02,0x02
	.byte 0x03,0x7b,0x01,0x28,0x02,0x01,0x00,0x01
	.byte 0x01,0x00,0x05,0x02
	.uaword HashPrint
	.byte 0x06,0x02,0x02,0x03,0xe2,0x01,0x01,0x10
	.byte 0x02,0x01,0x03,0x03,0x01,0x02,0x02,0x03
	.byte 0x7e,0x01,0x14,0x14,0x1c,0x02,0x01,0x03
	.byte 0x7e,0x01,0x14,0x02,0x01,0x03,0x7d,0x01
	.byte 0x18,0x0e,0x12,0x02,0x07,0x03,0x04,0x01
	.byte 0x02,0x01,0x00,0x01,0x01,0x00,0x05,0x02
	.uaword HashFindFreeKeyBlock
	.byte 0x06,0x02,0x01,0x03,0xf7,0x01,0x01,0x21
	.byte 0x02,0x01,0x03,0x16,0x01,0x02,0x02,0x03
	.byte 0x6e,0x01,0x10,0x11,0x02,0x01,0x03,0xf3
	.byte 0x7e,0x01,0x02,0x01,0x03,0x7d,0x01,0x02
	.byte 0x02,0x03,0x03,0x01,0x54,0x02,0x02,0x03
	.byte 0x94,0x01,0x01,0x02,0x01,0x03,0xed,0x7e
	.byte 0x01,0x02,0x03,0x03,0x8c,0x01,0x01,0x02
	.byte 0x01,0x03,0xf7,0x7e,0x01,0x02,0x01,0x03
	.byte 0x7c,0x01,0x14,0x0e,0x02,0x01,0x03,0x94
	.byte 0x01,0x01,0x02,0x01,0x03,0x79,0x01,0x02
	.byte 0x02,0x03,0x07,0x01,0x02,0x01,0x03,0x7c
	.byte 0x01,0x0e,0x10,0x02,0x02,0x03,0x7c,0x01
	.byte 0x02,0x01,0x03,0x09,0x01,0x02,0x03,0x03
	.byte 0x77,0x01,0x02,0x02,0x03,0xf0,0x7e,0x01
	.byte 0x02,0x01,0x03,0x9f,0x01,0x01,0x02,0x05
	.byte 0x03,0xe1,0x7e,0x01,0x02,0x09,0x03,0x03
	.byte 0x01,0x02,0x01,0x00,0x01,0x01
!  End sdCreateSection
!  Begin sdCreateSection : .debug_abbrev
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_abbrev"
	.byte 0x01,0x11,0x01,0x03,0x08,0x13,0x0b,0x1b
	.byte 0x08,0x85,0x44,0x08,0x87,0x44,0x08,0x25
	.byte 0x08,0x10,0x06,0x00,0x00,0x02,0x2e,0x00
	.byte 0x03,0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x0b,0x11,0x01,0x12,0x01,0x40,0x0a
	.byte 0x27,0x0c,0x49,0x13,0x88,0x44,0x0b,0x00
	.byte 0x00,0x03,0x24,0x00,0x03,0x08,0x3e,0x0b
	.byte 0x0b,0x0b,0x00,0x00,0x04,0x16,0x00,0x49
	.byte 0x13,0x03,0x08,0x3a,0x0b,0x00,0x00,0x05
	.byte 0x0f,0x00,0x49,0x13,0x00,0x00,0x06,0x13
	.byte 0x01,0x03,0x08,0x0b,0x0b,0x01,0x13,0x00
	.byte 0x00,0x07,0x0d,0x00,0x03,0x08,0x49,0x13
	.byte 0x38,0x0a,0x00,0x00,0x08,0x01,0x01,0x49
	.byte 0x13,0x0b,0x05,0x01,0x13,0x00,0x00,0x09
	.byte 0x21,0x00,0x49,0x13,0x2f,0x05,0x00,0x00
	.byte 0x0a,0x13,0x01,0x03,0x08,0x0b,0x05,0x01
	.byte 0x13,0x00,0x00,0x0b,0x2e,0x01,0x03,0x08
	.byte 0x3f,0x0c,0x17,0x0b,0x3a,0x0b,0x3b,0x0b
	.byte 0x11,0x01,0x12,0x01,0x40,0x0a,0x27,0x0c
	.byte 0x88,0x44,0x0b,0x01,0x13,0x00,0x00,0x0c
	.byte 0x05,0x00,0x49,0x13,0x03,0x08,0x3a,0x0b
	.byte 0x3b,0x0b,0x02,0x0a,0x00,0x00,0x0d,0x34
	.byte 0x00,0x03,0x08,0x49,0x13,0x17,0x0b,0x3a
	.byte 0x0b,0x3b,0x0b,0x02,0x0a,0x00,0x00,0x0e
	.byte 0x86,0x84,0x01,0x00,0x92,0x44,0x0b,0x91
	.byte 0x44,0x09,0x00,0x00,0x0f,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x17,0x0b,0x3a,0x0b,0x3b
	.byte 0x0b,0x11,0x01,0x12,0x01,0x40,0x0a,0x27
	.byte 0x0c,0x49,0x13,0x88,0x44,0x0b,0x01,0x13
	.byte 0x00,0x00,0x10,0x26,0x00,0x49,0x13,0x00
	.byte 0x00,0x11,0x34,0x00,0x03,0x08,0x49,0x13
	.byte 0x17,0x0b,0x3a,0x0b,0x3b,0x05,0x02,0x0a
	.byte 0x00,0x00,0x12,0x2e,0x01,0x03,0x08,0x3f
	.byte 0x0c,0x3c,0x0c,0x27,0x0c,0x49,0x13,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x13,0x05
	.byte 0x00,0x49,0x13,0x00,0x00,0x14,0x18,0x00
	.byte 0x00,0x00,0x15,0x2e,0x01,0x03,0x08,0x3f
	.byte 0x0c,0x3c,0x0c,0x27,0x0c,0x88,0x44,0x0b
	.byte 0x01,0x13,0x00,0x00,0x16,0x2e,0x01,0x03
	.byte 0x08,0x3f,0x0c,0x3c,0x0c,0x27,0x0c,0x88
	.byte 0x44,0x0b,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x9c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x05,0x80,0x00,0x00,0x00,0xfc
	.byte 0x4e,0x65,0x77,0x48,0x61,0x73,0x68,0x54
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x01
	.byte 0xd0,0x44,0x65,0x6c,0x65,0x74,0x65,0x48
	.byte 0x61,0x73,0x68,0x54,0x61,0x62,0x6c,0x65
	.byte 0x00,0x00,0x00,0x02,0x34,0x48,0x61,0x73
	.byte 0x68,0x4c,0x6f,0x6f,0x6b,0x75,0x70,0x00
	.byte 0x00,0x00,0x02,0xa4,0x48,0x61,0x73,0x68
	.byte 0x49,0x6e,0x73,0x65,0x72,0x74,0x00,0x00
	.byte 0x00,0x03,0x16,0x48,0x61,0x73,0x68,0x52
	.byte 0x65,0x6d,0x6f,0x76,0x65,0x00,0x00,0x00
	.byte 0x03,0x89,0x48,0x61,0x73,0x68,0x46,0x69
	.byte 0x72,0x73,0x74,0x45,0x6e,0x74,0x72,0x79
	.byte 0x00,0x00,0x00,0x03,0xdd,0x48,0x61,0x73
	.byte 0x68,0x50,0x72,0x69,0x6e,0x74,0x00,0x00
	.byte 0x00,0x04,0x36,0x48,0x61,0x73,0x68,0x46
	.byte 0x69,0x6e,0x64,0x46,0x72,0x65,0x65,0x4b
	.byte 0x65,0x79,0x42,0x6c,0x6f,0x63,0x6b,0x00
	.byte 0x00,0x00,0x00,0x00,0x00,0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_typenames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_typenames"
	.byte 0x00,0x00,0x00,0x38,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x05,0x80,0x00,0x00,0x01,0x2a
	.byte 0x47,0x4c,0x75,0x69,0x6e,0x74,0x00,0x00
	.byte 0x00,0x01,0x49,0x48,0x61,0x73,0x68,0x45
	.byte 0x6e,0x74,0x72,0x79,0x00,0x00,0x00,0x01
	.byte 0x9b,0x48,0x61,0x73,0x68,0x54,0x61,0x62
	.byte 0x6c,0x65,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection

! End Disassembling Debug Info

! Begin Disassembling Ident
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
	.ident	"@(#)assert.h\t1.10\t04/05/18 SMI"	! (/tmp/acompAAA.11106.9HaqSv:8)
	.ident	"@(#)stdlib.h\t1.51\t04/06/30 SMI"	! (/tmp/acompAAA.11106.9HaqSv:9)
	.ident	"@(#)stdlib_iso.h\t1.9\t04/09/28 SMI"	! (/tmp/acompAAA.11106.9HaqSv:10)
	.ident	"@(#)feature_tests.h\t1.25\t07/02/02 SMI"	! (/tmp/acompAAA.11106.9HaqSv:11)
	.ident	"@(#)ccompile.h\t1.2\t04/11/08 SMI"	! (/tmp/acompAAA.11106.9HaqSv:12)
	.ident	"@(#)isa_defs.h\t1.28\t07/02/01 SMI"	! (/tmp/acompAAA.11106.9HaqSv:13)
	.ident	"@(#)stdlib_c99.h\t1.2\t04/03/29 SMI"	! (/tmp/acompAAA.11106.9HaqSv:14)
	.ident	"@(#)stdio.h\t1.84\t04/09/28 SMI"	! (/tmp/acompAAA.11106.9HaqSv:15)
	.ident	"@(#)stdio_iso.h\t1.8\t05/08/16 SMI"	! (/tmp/acompAAA.11106.9HaqSv:16)
	.ident	"@(#)va_list.h\t1.15\t04/11/19 SMI"	! (/tmp/acompAAA.11106.9HaqSv:17)
	.ident	"@(#)stdio_tag.h\t1.4\t04/09/28 SMI"	! (/tmp/acompAAA.11106.9HaqSv:18)
	.ident	"@(#)stdio_impl.h\t1.15\t07/03/05 SMI"	! (/tmp/acompAAA.11106.9HaqSv:19)
	.ident	"@(#)stdio_c99.h\t1.2\t04/03/29 SMI"	! (/tmp/acompAAA.11106.9HaqSv:20)
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"	! (/tmp/acompAAA.11106.9HaqSv:84)
	.ident	"iropt: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (/tmp/acompAAA.11106.9HaqSv:85)
	.ident	"cg: Sun Compiler Common 12 SunOS_sparc Patch 124861-10 2008/11/18"	! (NO SOURCE LINE)
! End Disassembling Ident
