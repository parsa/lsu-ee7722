
	.section	".text",#alloc,#execinstr
	.align	8
	.skip	16

	! block 0

	.global	NewHashTable
	.type	NewHashTable,#function
NewHashTable:
	save	%sp,-104,%sp

	! block 1
.L13:
.L14:
.L16:

! File hash.c:
!    1	/* $Id: hash.c,v 1.3 1997/09/22 02:33:07 brianp Exp $ */
!    2	
!    3	/*
!    4	 * Mesa 3-D graphics library
!    5	 * Version:  2.5
!    6	 * Copyright (C) 1995-1997  Brian Paul
!    7	 *
!    8	 * This library is free software; you can redistribute it and/or
!    9	 * modify it under the terms of the GNU Library General Public
!   10	 * License as published by the Free Software Foundation; either
!   11	 * version 2 of the License, or (at your option) any later version.
!   12	 *
!   13	 * This library is distributed in the hope that it will be useful,
!   14	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
!   15	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!   16	 * Library General Public License for more details.
!   17	 *
!   18	 * You should have received a copy of the GNU Library General Public
!   19	 * License along with this library; if not, write to the Free
!   20	 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
!   21	 */
!   22	
!   24	/*
!   25	 * $Log: hash.c,v $
!   26	 * Revision 1.3  1997/09/22 02:33:07  brianp
!   27	 * added HashRemove() and HashFirstEntry()
!   28	 *
!   29	 * Revision 1.2  1997/09/03 13:13:45  brianp
!   30	 * added a few pointer casts
!   31	 *
!   32	 * Revision 1.1  1997/08/22 01:15:10  brianp
!   33	 * Initial revision
!   34	 *
!   35	 */
!   36	
!   38	#ifdef PC_HEADER
!   39	#include "all.h"
!   40	#else
!   41	#include <assert.h>
!   42	#include <stdlib.h>
!   43	#include <stdio.h>
!   44	#include "hash.h"
!   45	#endif
!   46	
!   48	/*
!   49	 * Generic hash table.  Only dependency is the GLuint datatype.
!   50	 *
!   51	 * This is used to implement display list and texture object lookup.
!   52	 * NOTE: key=0 is illegal.
!   53	 */
!   54	
!   56	#define TABLE_SIZE 1001
!   57	
!   58	struct HashEntry {
!   59	   GLuint Key;
!   60	   void *Data;
!   61	   struct HashEntry *Next;
!   62	};
!   63	
!   64	struct HashTable {
!   65	   struct HashEntry *Table[TABLE_SIZE];
!   66	   GLuint MaxKey;
!   67	};
!   68	
!   71	/*
!   72	 * Return pointer to a new, empty hash table.
!   73	 */
!   74	struct HashTable *NewHashTable(void)
!   75	{
!   76	   return (struct HashTable *) calloc(sizeof (struct HashTable), 1);

	mov	4008,%o0
	call	calloc
	mov	1,%o1
	ba	.L12
	st	%o0,[%fp-4]

	! block 2

	! block 3
.L17:
.L18:
.L12:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	NewHashTable,(.-NewHashTable)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	DeleteHashTable
	.type	DeleteHashTable,#function
DeleteHashTable:
	save	%sp,-112,%sp

	! block 1
.L21:
	st	%i0,[%fp+68]

	! block 2
.L22:
.L24:

! File hash.c:
!   77	}
!   78	
!   81	/*
!   82	 * Delete a hash table.
!   83	 */
!   84	void DeleteHashTable(struct HashTable *table)
!   85	{
!   86	   GLuint i;
!   87	   assert(table);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	bne	.L26
	nop

	! block 3
.L27:
	sethi	%hi(.L28),%l0
	or	%l0,%lo(.L28),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	87,%o2
	ba	.L25
	nop

	! block 4
.L26:
	mov	1,%l0
	ba	.L30
	st	%l0,[%fp-8]

	! block 5
.L25:
	st	%g0,[%fp-8]

	! block 6
.L30:
.L31:
.L32:

!   88	   for (i=0;i<TABLE_SIZE;i++) {

	st	%g0,[%fp-4]

	! block 7
.L36:
.L33:
.L37:
.L38:
.L39:

!   89	      struct HashEntry *entry = table->Table[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	st	%l0,[%fp-12]

	! block 8
.L40:
.L44:

!   90	      while (entry) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L43
	nop

	! block 9
.L45:
.L41:
.L46:
.L47:
.L48:

!   91		 struct HashEntry *next = entry->Next;

	ld	[%fp-12],%l0
	ld	[%l0+8],%l0
	st	%l0,[%fp-16]

	! block 10
.L49:

!   92		 free(entry);

	ld	[%fp-12],%l0
	call	free
	mov	%l0,%o0

	! block 11
.L50:

!   93		 entry = next;

	ld	[%fp-16],%l0
	st	%l0,[%fp-12]

	! block 12
.L51:
.L52:
.L53:
	ld	[%fp-12],%l0
	cmp	%l0,%g0
	bne	.L41
	nop

	! block 13
.L54:
.L43:
.L55:
.L56:
.L57:
.L58:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,1001
	blu	.L33
	nop

	! block 14
.L59:
.L35:
.L60:
.L61:

!   94	      }
!   95	   }
!   96	   free(table);

	ld	[%fp+68],%l0
	call	free
	mov	%l0,%o0

	! block 15
.L62:
.L63:
.L20:
	jmp	%i7+8
	restore
	.size	DeleteHashTable,(.-DeleteHashTable)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	HashLookup
	.type	HashLookup,#function
HashLookup:
	save	%sp,-120,%sp

	! block 1
.L66:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L67:
.L69:

! File hash.c:
!   97	}
!   98	
!  101	/*
!  102	 * Lookup an entry in the hash table.
!  103	 * Input:  table - the hash table
!  104	 *         key - the key
!  105	 * Return:  user data pointer or NULL if key not in table
!  106	 */
!  107	void *HashLookup(const struct HashTable *table, GLuint key)
!  108	{
!  109	   GLuint pos;
!  110	   struct HashEntry *entry;
!  111	
!  112	   assert(table);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	bne	.L71
	nop

	! block 3
.L72:
	sethi	%hi(.L73),%l0
	or	%l0,%lo(.L73),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	112,%o2
	ba	.L70
	nop

	! block 4
.L71:
	mov	1,%l0
	ba	.L75
	st	%l0,[%fp-16]

	! block 5
.L70:
	st	%g0,[%fp-16]

	! block 6
.L75:
.L76:

!  113	   assert(key);

	ld	[%fp+72],%l0
	cmp	%l0,%g0
	bne	.L78
	nop

	! block 7
.L79:
	sethi	%hi(.L80),%l0
	or	%l0,%lo(.L80),%l0
	add	%l0,4,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	113,%o2
	ba	.L77
	nop

	! block 8
.L78:
	mov	1,%l0
	ba	.L82
	st	%l0,[%fp-20]

	! block 9
.L77:
	st	%g0,[%fp-20]

	! block 10
.L82:
.L83:

!  115	   pos = key % TABLE_SIZE;

	ld	[%fp+72],%l0
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l0,1001,%g1
	umul	%g1,1001,%g1
	sub	%l0,%g1,%l0
	st	%l0,[%fp-8]

	! block 11
.L84:

!  116	   entry = table->Table[pos];

	ld	[%fp+68],%l2
	ld	[%fp-8],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	st	%l0,[%fp-12]

	! block 12
.L85:
.L89:

!  117	   while (entry) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L88
	nop

	! block 13
.L90:
.L86:
.L91:
.L92:
.L93:
.L95:

!  118	      if (entry->Key == key) {

	ld	[%fp-12],%l0
	ld	[%l0+0],%l1
	ld	[%fp+72],%l0
	cmp	%l1,%l0
	bne	.L94
	nop

	! block 14
.L96:
.L97:
.L98:
.L99:

!  119		 return entry->Data;

	ld	[%fp-12],%l0
	ld	[%l0+4],%l0
	ba	.L65
	st	%l0,[%fp-4]

	! block 15
.L100:
.L101:
.L94:
.L102:
.L103:

!  120	      }
!  121	      entry = entry->Next;

	ld	[%fp-12],%l0
	ld	[%l0+8],%l0
	st	%l0,[%fp-12]

	! block 16
.L104:
.L105:
.L106:
	ld	[%fp-12],%l0
	cmp	%l0,%g0
	bne	.L86
	nop

	! block 17
.L107:
.L88:
.L108:
.L109:

!  122	   }
!  123	   return NULL;

	ba	.L65
	st	%g0,[%fp-4]

	! block 18

	! block 19
.L110:
.L111:
.L65:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	HashLookup,(.-HashLookup)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	HashInsert
	.type	HashInsert,#function
HashInsert:
	save	%sp,-112,%sp

	! block 1
.L114:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]
	st	%i2,[%fp+76]

	! block 2
.L115:
.L117:

! File hash.c:
!  124	}
!  125	
!  128	/*
!  129	 * Insert into the hash table.  If an entry with this key already exists
!  130	 * we'll replace the existing entry.
!  131	 * Input:  table - the hash table
!  132	 *         key - the key (not zero)
!  133	 *         data - pointer to user data
!  134	 */
!  135	void HashInsert(struct HashTable *table, GLuint key, void *data)
!  136	{
!  137	   /* search for existing entry with this key */
!  138	   GLuint pos;
!  139	   struct HashEntry *entry;
!  140	
!  141	   assert(table);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	bne	.L119
	nop

	! block 3
.L120:
	sethi	%hi(.L121),%l0
	or	%l0,%lo(.L121),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	141,%o2
	ba	.L118
	nop

	! block 4
.L119:
	mov	1,%l0
	ba	.L123
	st	%l0,[%fp-12]

	! block 5
.L118:
	st	%g0,[%fp-12]

	! block 6
.L123:
.L124:

!  142	   assert(key);

	ld	[%fp+72],%l0
	cmp	%l0,%g0
	bne	.L126
	nop

	! block 7
.L127:
	sethi	%hi(.L128),%l0
	or	%l0,%lo(.L128),%l0
	add	%l0,4,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	142,%o2
	ba	.L125
	nop

	! block 8
.L126:
	mov	1,%l0
	ba	.L130
	st	%l0,[%fp-16]

	! block 9
.L125:
	st	%g0,[%fp-16]

	! block 10
.L130:
.L131:
.L133:

!  144	   if (key > table->MaxKey)

	ld	[%fp+72],%l1
	ld	[%fp+68],%l0
	ld	[%l0+4004],%l0
	cmp	%l1,%l0
	bleu	.L132
	nop

	! block 11
.L134:
.L135:
.L136:

!  145	      table->MaxKey = key;

	ld	[%fp+72],%l1
	ld	[%fp+68],%l0
	st	%l1,[%l0+4004]

	! block 12
.L137:
.L132:
.L138:
.L139:

!  147	   pos = key % TABLE_SIZE;

	ld	[%fp+72],%l0
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l0,1001,%g1
	umul	%g1,1001,%g1
	sub	%l0,%g1,%l0
	st	%l0,[%fp-4]

	! block 13
.L140:

!  148	   entry = table->Table[pos];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	st	%l0,[%fp-8]

	! block 14
.L141:
.L145:

!  149	   while (entry) {

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L144
	nop

	! block 15
.L146:
.L142:
.L147:
.L148:
.L149:
.L151:

!  150	      if (entry->Key == key) {

	ld	[%fp-8],%l0
	ld	[%l0+0],%l1
	ld	[%fp+72],%l0
	cmp	%l1,%l0
	bne	.L150
	nop

	! block 16
.L152:
.L153:
.L154:
.L155:

!  151	         /* replace entry's data */
!  152		 entry->Data = data;

	ld	[%fp+76],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+4]

	! block 17
.L156:

!  153		 return;

	ba	.L113
	nop

	! block 18
.L157:
.L158:
.L150:
.L159:
.L160:

!  154	      }
!  155	      entry = entry->Next;

	ld	[%fp-8],%l0
	ld	[%l0+8],%l0
	st	%l0,[%fp-8]

	! block 19
.L161:
.L162:
.L163:
	ld	[%fp-8],%l0
	cmp	%l0,%g0
	bne	.L142
	nop

	! block 20
.L164:
.L144:
.L165:
.L166:

!  156	   }
!  157	
!  158	   /* alloc and insert new table entry */
!  159	   entry = (struct HashEntry *) calloc(sizeof(struct HashEntry), 1);

	mov	12,%o0
	call	calloc
	mov	1,%o1
	st	%o0,[%fp-8]

	! block 21
.L167:

!  160	   entry->Key = key;

	ld	[%fp+72],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+0]

	! block 22
.L168:

!  161	   entry->Data = data;

	ld	[%fp+76],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+4]

	! block 23
.L169:

!  162	   entry->Next = table->Table[pos];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l1
	ld	[%fp-8],%l0
	st	%l1,[%l0+8]

	! block 24
.L170:

!  163	   table->Table[pos] = entry;

	ld	[%fp-8],%l3
	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]

	! block 25
.L171:
.L172:
.L113:
	jmp	%i7+8
	restore
	.size	HashInsert,(.-HashInsert)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	HashRemove
	.type	HashRemove,#function
HashRemove:
	save	%sp,-120,%sp

	! block 1
.L175:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L176:
.L178:

! File hash.c:
!  164	}
!  165	
!  168	/*
!  169	 * Remove an entry from the hash table.
!  170	 * Input:  table - the hash table
!  171	 *         key - key of entry to remove
!  172	 */
!  173	void HashRemove(struct HashTable *table, GLuint key)
!  174	{
!  175	   GLuint pos;
!  176	   struct HashEntry *entry, *prev;
!  177	
!  178	   assert(table);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	bne	.L180
	nop

	! block 3
.L181:
	sethi	%hi(.L182),%l0
	or	%l0,%lo(.L182),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	178,%o2
	ba	.L179
	nop

	! block 4
.L180:
	mov	1,%l0
	ba	.L184
	st	%l0,[%fp-16]

	! block 5
.L179:
	st	%g0,[%fp-16]

	! block 6
.L184:
.L185:

!  179	   assert(key);

	ld	[%fp+72],%l0
	cmp	%l0,%g0
	bne	.L187
	nop

	! block 7
.L188:
	sethi	%hi(.L189),%l0
	or	%l0,%lo(.L189),%l0
	add	%l0,4,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	179,%o2
	ba	.L186
	nop

	! block 8
.L187:
	mov	1,%l0
	ba	.L191
	st	%l0,[%fp-20]

	! block 9
.L186:
	st	%g0,[%fp-20]

	! block 10
.L191:
.L192:

!  181	   pos = key % TABLE_SIZE;

	ld	[%fp+72],%l0
	wr	%g0,%g0,%y
	nop
	nop
	nop
	udiv	%l0,1001,%g1
	umul	%g1,1001,%g1
	sub	%l0,%g1,%l0
	st	%l0,[%fp-4]

	! block 11
.L193:

!  182	   prev = NULL;

	st	%g0,[%fp-12]

	! block 12
.L194:

!  183	   entry = table->Table[pos];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	st	%l0,[%fp-8]

	! block 13
.L195:
.L199:

!  184	   while (entry) {

	ld	[%fp-8],%l0
	cmp	%l0,%g0
	be	.L198
	nop

	! block 14
.L200:
.L196:
.L201:
.L202:
.L203:
.L205:

!  185	      if (entry->Key == key) {

	ld	[%fp-8],%l0
	ld	[%l0+0],%l1
	ld	[%fp+72],%l0
	cmp	%l1,%l0
	bne	.L204
	nop

	! block 15
.L206:
.L207:
.L208:
.L209:
.L211:

!  186	         /* found it! */
!  187	         if (prev) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L210
	nop

	! block 16
.L212:
.L213:
.L214:
.L215:

!  188	            prev->Next = entry->Next;

	ld	[%fp-8],%l0
	ld	[%l0+8],%l1
	ld	[%fp-12],%l0
	st	%l1,[%l0+8]

	! block 17
.L216:
.L217:
	ba	.L218
	nop

	! block 18
.L210:
.L219:
.L220:
.L221:

!  189	         }
!  190	         else {
!  191	            table->Table[pos] = entry->Next;

	ld	[%fp-8],%l0
	ld	[%l0+8],%l3
	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	st	%l3,[%l2+%l1]

	! block 19
.L222:
.L223:
.L218:
.L224:
.L225:

!  192	         }
!  193	         free(entry);

	ld	[%fp-8],%l0
	call	free
	mov	%l0,%o0

	! block 20
.L226:

!  194		 return;

	ba	.L174
	nop

	! block 21
.L227:
.L228:
.L204:
.L229:
.L230:

!  195	      }
!  196	      prev = entry;

	ld	[%fp-8],%l0
	st	%l0,[%fp-12]

	! block 22
.L231:

!  197	      entry = entry->Next;

	ld	[%fp-8],%l0
	ld	[%l0+8],%l0
	st	%l0,[%fp-8]

	! block 23
.L232:
.L233:
.L234:
	ld	[%fp-8],%l0
	cmp	%l0,%g0
	bne	.L196
	nop

	! block 24
.L235:
.L198:
.L236:

	! block 25
.L237:
.L238:
.L174:
	jmp	%i7+8
	restore
	.size	HashRemove,(.-HashRemove)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	HashFirstEntry
	.type	HashFirstEntry,#function
HashFirstEntry:
	save	%sp,-112,%sp

	! block 1
.L241:
	st	%i0,[%fp+68]

	! block 2
.L242:
.L244:

! File hash.c:
!  198	   }
!  199	}
!  200	
!  203	/*
!  204	 * Return the key of the "first" entry in the hash table.
!  205	 * By calling this function until zero is returned we can get
!  206	 * the keys of all entries in the table.
!  207	 */
!  208	GLuint HashFirstEntry(const struct HashTable *table)
!  209	{
!  210	   GLuint pos;
!  211	   assert(table);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	bne	.L246
	nop

	! block 3
.L247:
	sethi	%hi(.L248),%l0
	or	%l0,%lo(.L248),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	211,%o2
	ba	.L245
	nop

	! block 4
.L246:
	mov	1,%l0
	ba	.L250
	st	%l0,[%fp-12]

	! block 5
.L245:
	st	%g0,[%fp-12]

	! block 6
.L250:
.L251:
.L252:

!  212	   for (pos=0; pos < TABLE_SIZE; pos++) {

	st	%g0,[%fp-8]

	! block 7
.L256:
.L253:
.L257:
.L258:
.L259:
.L261:

!  213	      if (table->Table[pos])

	ld	[%fp+68],%l2
	ld	[%fp-8],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	cmp	%l0,%g0
	be	.L260
	nop

	! block 8
.L262:
.L263:
.L264:

!  214	         return table->Table[pos]->Key;

	ld	[%fp+68],%l2
	ld	[%fp-8],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	ld	[%l0+0],%l0
	ba	.L240
	st	%l0,[%fp-4]

	! block 9
.L265:
.L260:
.L266:
.L267:
.L268:
.L269:
	ld	[%fp-8],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-8]
	ld	[%fp-8],%l0
	cmp	%l0,1001
	blu	.L253
	nop

	! block 10
.L270:
.L255:
.L271:
.L272:

!  215	   }
!  216	   return 0;

	ba	.L240
	st	%g0,[%fp-4]

	! block 11

	! block 12
.L273:
.L274:
.L240:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	HashFirstEntry,(.-HashFirstEntry)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	HashPrint
	.type	HashPrint,#function
HashPrint:
	save	%sp,-112,%sp

	! block 1
.L277:
	st	%i0,[%fp+68]

	! block 2
.L278:
.L280:

! File hash.c:
!  217	}
!  218	
!  221	/*
!  222	 * Dump contents of hash table for debugging.
!  223	 */
!  224	void HashPrint(const struct HashTable *table)
!  225	{
!  226	   GLuint i;
!  227	   assert(table);

	ld	[%fp+68],%l0
	cmp	%l0,%g0
	bne	.L282
	nop

	! block 3
.L283:
	sethi	%hi(.L284),%l0
	or	%l0,%lo(.L284),%l0
	add	%l0,8,%l1
	mov	%l0,%o0
	mov	%l1,%o1
	call	__assert
	mov	227,%o2
	ba	.L281
	nop

	! block 4
.L282:
	mov	1,%l0
	ba	.L286
	st	%l0,[%fp-8]

	! block 5
.L281:
	st	%g0,[%fp-8]

	! block 6
.L286:
.L287:
.L288:

!  228	   for (i=0;i<TABLE_SIZE;i++) {

	st	%g0,[%fp-4]

	! block 7
.L292:
.L289:
.L293:
.L294:
.L295:

!  229	      struct HashEntry *entry = table->Table[i];

	ld	[%fp+68],%l2
	ld	[%fp-4],%l0
	sll	%l0,2,%l1
	ld	[%l2+%l1],%l0
	st	%l0,[%fp-12]

	! block 8
.L296:
.L300:

!  230	      while (entry) {

	ld	[%fp-12],%l0
	cmp	%l0,%g0
	be	.L299
	nop

	! block 9
.L_y0:
	sethi	%hi(.L305),%l3
	or	%l3,%lo(.L305),%l3
.L301:
.L297:
.L302:
.L303:
.L304:

!  231		 printf("%u %p\n", entry->Key, entry->Data);

	ld	[%fp-12],%l0
	ld	[%l0+0],%l1
	ld	[%l0+4],%l2
	mov	%l3,%o0
	mov	%l1,%o1
	call	printf
	mov	%l2,%o2

	! block 10
.L306:

!  232		 entry = entry->Next;

	ld	[%fp-12],%l0
	ld	[%l0+8],%l0
	st	%l0,[%fp-12]

	! block 11
.L307:
.L308:
.L309:
	ld	[%fp-12],%l0
	cmp	%l0,%g0
	bne	.L297
	nop

	! block 12
.L310:
.L299:
.L311:
.L312:
.L313:
.L314:
	ld	[%fp-4],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-4]
	ld	[%fp-4],%l0
	cmp	%l0,1001
	blu	.L289
	nop

	! block 13
.L315:
.L291:
.L316:

	! block 14
.L317:
.L318:
.L276:
	jmp	%i7+8
	restore
	.size	HashPrint,(.-HashPrint)
	.align	8
	.align	8
	.skip	16

	! block 0

	.global	HashFindFreeKeyBlock
	.type	HashFindFreeKeyBlock,#function
HashFindFreeKeyBlock:
	save	%sp,-120,%sp

	! block 1
.L321:
	st	%i0,[%fp+68]
	st	%i1,[%fp+72]

	! block 2
.L322:
.L324:

! File hash.c:
!  233	      }
!  234	   }
!  235	}
!  236	
!  239	/*
!  240	 * Find a block of 'numKeys' adjacent unused hash keys.
!  241	 * Input:  table - the hash table
!  242	 *         numKeys - number of keys needed
!  243	 * Return:  startint key of free block or 0 if failure
!  244	 */
!  245	GLuint HashFindFreeKeyBlock(const struct HashTable *table, GLuint numKeys)
!  246	{
!  247	   GLuint maxKey = ~0;

	mov	-1,%l0
	st	%l0,[%fp-8]

	! block 3
.L325:
.L327:

!  248	   if (maxKey - numKeys > table->MaxKey) {

	ld	[%fp-8],%l0
	ld	[%fp+72],%l1
	sub	%l0,%l1,%l1
	ld	[%fp+68],%l0
	ld	[%l0+4004],%l0
	cmp	%l1,%l0
	bleu	.L326
	nop

	! block 4
.L328:
.L329:
.L330:
.L331:

!  249	      /* the quick solution */
!  250	      return table->MaxKey + 1;

	ld	[%fp+68],%l0
	ld	[%l0+4004],%l0
	add	%l0,1,%l0
	ba	.L320
	st	%l0,[%fp-4]

	! block 5
.L332:
.L333:
.L326:
.L334:
.L335:
.L336:

!  251	   }
!  252	   else {
!  253	      /* the slow solution */
!  254	      GLuint freeCount = 0;

	st	%g0,[%fp-12]

	! block 6
.L337:

!  255	      GLuint freeStart = 0;

	st	%g0,[%fp-16]

	! block 7
.L338:
.L339:

!  256	      GLuint key;
!  257	      for (key=0; key!=maxKey; key++) {

	ld	[%fp-8],%l0
	cmp	%g0,%l0
	be	.L342
	st	%g0,[%fp-20]

	! block 8
.L343:
.L340:
.L344:
.L345:
.L346:
.L348:

!  258		 if (HashLookup(table, key)) {

	ld	[%fp+68],%l0
	ld	[%fp-20],%l1
	mov	%l0,%o0
	call	HashLookup
	mov	%l1,%o1
	cmp	%o0,%g0
	be	.L347
	nop

	! block 9
.L349:
.L350:
.L351:
.L352:

!  259		    /* darn, this key is already in use */
!  260		    freeCount = 0;

	st	%g0,[%fp-12]

	! block 10
.L353:

!  261		    freeStart = key+1;

	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-16]

	! block 11
.L354:
.L355:
	ba	.L356
	nop

	! block 12
.L347:
.L357:
.L358:
.L359:

!  262		 }
!  263		 else {
!  264		    /* this key not in use, check if we've found enough */
!  265		    freeCount++;

	ld	[%fp-12],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-12]

	! block 13
.L360:
.L362:

!  266		    if (freeCount == numKeys) {

	ld	[%fp-12],%l1
	ld	[%fp+72],%l0
	cmp	%l1,%l0
	bne	.L361
	nop

	! block 14
.L363:
.L364:
.L365:
.L366:

!  267		       return freeStart;

	ld	[%fp-16],%l0
	ba	.L320
	st	%l0,[%fp-4]

	! block 15
.L367:
.L368:
.L361:
.L369:
.L370:
.L371:
.L356:
.L372:
.L373:
.L374:
.L375:
	ld	[%fp-20],%l0
	add	%l0,1,%l0
	st	%l0,[%fp-20]
	ld	[%fp-20],%l1
	ld	[%fp-8],%l0
	cmp	%l1,%l0
	bne	.L340
	nop

	! block 16
.L376:
.L342:
.L377:
.L378:

!  268		    }
!  269		 }
!  270	      }
!  271	      /* cannot allocate a block of numKeys consecutive keys */
!  272	      return 0;

	ba	.L320
	st	%g0,[%fp-4]

	! block 17
.L379:
.L380:
.L381:

	! block 18
.L382:
.L383:
.L320:
	ld	[%fp-4],%l0
	mov	%l0,%i0
	jmp	%i7+8
	restore
	.size	HashFindFreeKeyBlock,(.-HashFindFreeKeyBlock)
	.align	8

	.section	".rodata1",#alloc
	.align	4
.L28:
	.ascii	"table\000"
	.skip	2
	.type	.L28,#object
	.size	.L28,8
	.align	4
.L29:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L29,#object
	.size	.L29,8
	.align	4
.L73:
	.ascii	"table\000"
	.skip	2
	.type	.L73,#object
	.size	.L73,8
	.align	4
.L74:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L74,#object
	.size	.L74,8
	.align	4
.L80:
	.ascii	"key\000"
	.type	.L80,#object
	.size	.L80,4
	.align	4
.L81:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L81,#object
	.size	.L81,8
	.align	4
.L121:
	.ascii	"table\000"
	.skip	2
	.type	.L121,#object
	.size	.L121,8
	.align	4
.L122:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L122,#object
	.size	.L122,8
	.align	4
.L128:
	.ascii	"key\000"
	.type	.L128,#object
	.size	.L128,4
	.align	4
.L129:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L129,#object
	.size	.L129,8
	.align	4
.L182:
	.ascii	"table\000"
	.skip	2
	.type	.L182,#object
	.size	.L182,8
	.align	4
.L183:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L183,#object
	.size	.L183,8
	.align	4
.L189:
	.ascii	"key\000"
	.type	.L189,#object
	.size	.L189,4
	.align	4
.L190:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L190,#object
	.size	.L190,8
	.align	4
.L248:
	.ascii	"table\000"
	.skip	2
	.type	.L248,#object
	.size	.L248,8
	.align	4
.L249:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L249,#object
	.size	.L249,8
	.align	4
.L284:
	.ascii	"table\000"
	.skip	2
	.type	.L284,#object
	.size	.L284,8
	.align	4
.L285:
	.ascii	"hash.c\000"
	.skip	1
	.type	.L285,#object
	.size	.L285,8
	.align	4
.L305:
	.ascii	"%u %p\n\000"
	.type	.L305,#object
	.size	.L305,7
	.section	".bss",#alloc,#write
Bbss.bss:
	.section	".data",#alloc,#write
Ddata.data:
	.section	".rodata",#alloc
Drodata.rodata:

	.file	"hash.c"
	.ident	"@(#)assert.h	1.10	04/05/18 SMI"
	.ident	"@(#)stdlib.h	1.51	04/06/30 SMI"
	.ident	"@(#)stdlib_iso.h	1.9	04/09/28 SMI"
	.ident	"@(#)feature_tests.h	1.25	07/02/02 SMI"
	.ident	"@(#)ccompile.h	1.2	04/11/08 SMI"
	.ident	"@(#)isa_defs.h	1.28	07/02/01 SMI"
	.ident	"@(#)stdlib_c99.h	1.2	04/03/29 SMI"
	.ident	"@(#)stdio.h	1.84	04/09/28 SMI"
	.ident	"@(#)stdio_iso.h	1.8	05/08/16 SMI"
	.ident	"@(#)va_list.h	1.15	04/11/19 SMI"
	.ident	"@(#)stdio_tag.h	1.4	04/09/28 SMI"
	.ident	"@(#)stdio_impl.h	1.15	07/03/05 SMI"
	.ident	"@(#)stdio_c99.h	1.2	04/03/29 SMI"
	.ident	"acomp: Sun C 5.9 SunOS_sparc 2007/05/03"
!  Begin sdCreateSection : .debug_loc
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
	.section ".debug_loc"
!  End sdCreateSection
!  Begin sdCreateSection : .debug_info
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_abbrev, lab2=, loff=0
!   reloc[1]: knd=2, off=251, siz=4, lab1=.debug_line, lab2=, loff=0
!   reloc[2]: knd=0, off=273, siz=4, lab1=NewHashTable, lab2=, loff=0
!   reloc[3]: knd=0, off=277, siz=4, lab1=.L18, lab2=, loff=0
!   reloc[4]: knd=0, off=488, siz=4, lab1=DeleteHashTable, lab2=, loff=0
!   reloc[5]: knd=0, off=492, siz=4, lab1=.L63, lab2=, loff=0
!   reloc[6]: knd=0, off=535, siz=4, lab1=.L31, lab2=, loff=0
!   reloc[7]: knd=0, off=539, siz=4, lab1=.L60, lab2=, loff=0
!   reloc[8]: knd=0, off=544, siz=4, lab1=.L37, lab2=, loff=0
!   reloc[9]: knd=0, off=548, siz=4, lab1=.L57, lab2=, loff=0
!   reloc[10]: knd=0, off=553, siz=4, lab1=.L38, lab2=, loff=0
!   reloc[11]: knd=0, off=557, siz=4, lab1=.L56, lab2=, loff=0
!   reloc[12]: knd=0, off=579, siz=4, lab1=.L40, lab2=, loff=0
!   reloc[13]: knd=0, off=583, siz=4, lab1=.L55, lab2=, loff=0
!   reloc[14]: knd=0, off=588, siz=4, lab1=.L46, lab2=, loff=0
!   reloc[15]: knd=0, off=592, siz=4, lab1=.L52, lab2=, loff=0
!   reloc[16]: knd=0, off=597, siz=4, lab1=.L47, lab2=, loff=0
!   reloc[17]: knd=0, off=601, siz=4, lab1=.L51, lab2=, loff=0
!   reloc[18]: knd=0, off=644, siz=4, lab1=HashLookup, lab2=, loff=0
!   reloc[19]: knd=0, off=648, siz=4, lab1=.L111, lab2=, loff=0
!   reloc[20]: knd=0, off=755, siz=4, lab1=HashInsert, lab2=, loff=0
!   reloc[21]: knd=0, off=759, siz=4, lab1=.L172, lab2=, loff=0
!   reloc[22]: knd=0, off=868, siz=4, lab1=HashRemove, lab2=, loff=0
!   reloc[23]: knd=0, off=872, siz=4, lab1=.L238, lab2=, loff=0
!   reloc[24]: knd=0, off=985, siz=4, lab1=HashFirstEntry, lab2=, loff=0
!   reloc[25]: knd=0, off=989, siz=4, lab1=.L274, lab2=, loff=0
!   reloc[26]: knd=0, off=1063, siz=4, lab1=HashPrint, lab2=, loff=0
!   reloc[27]: knd=0, off=1067, siz=4, lab1=.L318, lab2=, loff=0
!   reloc[28]: knd=0, off=1110, siz=4, lab1=.L287, lab2=, loff=0
!   reloc[29]: knd=0, off=1114, siz=4, lab1=.L316, lab2=, loff=0
!   reloc[30]: knd=0, off=1119, siz=4, lab1=.L293, lab2=, loff=0
!   reloc[31]: knd=0, off=1123, siz=4, lab1=.L313, lab2=, loff=0
!   reloc[32]: knd=0, off=1128, siz=4, lab1=.L294, lab2=, loff=0
!   reloc[33]: knd=0, off=1132, siz=4, lab1=.L312, lab2=, loff=0
!   reloc[34]: knd=0, off=1193, siz=4, lab1=HashFindFreeKeyBlock, lab2=, loff=0
!   reloc[35]: knd=0, off=1197, siz=4, lab1=.L383, lab2=, loff=0
!   reloc[36]: knd=0, off=1268, siz=4, lab1=.L325, lab2=, loff=0
!   reloc[37]: knd=0, off=1272, siz=4, lab1=.L381, lab2=, loff=0
!   reloc[38]: knd=0, off=1277, siz=4, lab1=.L334, lab2=, loff=0
!   reloc[39]: knd=0, off=1281, siz=4, lab1=.L380, lab2=, loff=0
!   reloc[40]: knd=0, off=1286, siz=4, lab1=.L335, lab2=, loff=0
!   reloc[41]: knd=0, off=1290, siz=4, lab1=.L379, lab2=, loff=0
	.section ".debug_info"
	.byte 0x00,0x00,0x05,0xf0,0x00,0x02
	.uaword %section_symbol(".debug_abbrev")
	.byte 0x04,0x01
	.ascii "hash.c\0"
	.byte 0x0c
	.ascii "/home/faculty/koppel/teach/gpcom/gpup/rsim/mesa/no-opt\0"
	.ascii " /local/SUNWspro/prod/bin/cc -g -xtarget=ultraT2 -S  hash.c -W0,-xp\\$XAa59JCRsd3Lm1K.\0"
	.ascii "Xa;g;R=Sun C 5.9 SunOS_sparc 2007/05/03;G=$XAa59JCRsd3Lm1K.;backend;raw;cd;\0"
	.ascii "DBG_GEN 5.2.1\0"
	.uaword %section_symbol(".debug_line")
	.byte 0x02
	.ascii "NewHashTable\0"
	.byte 0x01,0x02,0x01,0x4b
	.uaword NewHashTable
	.uaword .L18
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0xce,0x01
	.byte 0x03
	.ascii "unsigned\0"
	.byte 0x07,0x04,0x04,0x00,0x00,0x01,0x21
	.ascii "GLuint\0"
	.byte 0x02,0x03
	.ascii "void\0"
	.byte 0x05,0x00,0x05,0x00,0x00,0x01,0x3a,0x05
	.byte 0x00,0x00,0x01,0x4c,0x06
	.ascii "HashEntry\0"
	.byte 0x0c,0x00,0x00,0x01,0x83,0x07
	.ascii "Key\0"
	.byte 0x00,0x00,0x01,0x2d,0x02,0x23,0x00,0x07
	.ascii "Data\0"
	.byte 0x00,0x00,0x01,0x42,0x02,0x23,0x04,0x07
	.ascii "Next\0"
	.byte 0x00,0x00,0x01,0x47,0x02,0x23,0x08,0x00
	.byte 0x03
	.ascii "long\0"
	.byte 0x05,0x04,0x08,0x00,0x00,0x01,0x47,0x0f
	.byte 0xa4,0x00,0x00,0x01,0x9e,0x09,0x00,0x00
	.byte 0x01,0x83,0x03,0xe8,0x00,0x0a
	.ascii "HashTable\0"
	.byte 0x0f,0xa8,0x00,0x00,0x01,0xce,0x07
	.ascii "Table\0"
	.byte 0x00,0x00,0x01,0x8b,0x02,0x23,0x00,0x07
	.ascii "MaxKey\0"
	.byte 0x00,0x00,0x01,0x2d,0x03,0x23,0xa4,0x1f
	.byte 0x00,0x05,0x00,0x00,0x01,0x9e,0x0b
	.ascii "DeleteHashTable\0"
	.byte 0x01,0x02,0x01,0x55
	.uaword DeleteHashTable
	.uaword .L63
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x02,0x74
	.byte 0x0c,0x00,0x00,0x01,0xce
	.ascii "table\0"
	.byte 0x01,0x54,0x03,0x91,0xc4,0x00,0x0d
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0x56,0x02
	.byte 0x91,0x7c,0x0e
	.uaword .L31
	.uaword .L60
	.byte 0x0e
	.uaword .L37
	.uaword .L57
	.byte 0x0e
	.uaword .L38
	.uaword .L56
	.byte 0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0x59,0x02
	.byte 0x91,0x74,0x0e
	.uaword .L40
	.uaword .L55
	.byte 0x0e
	.uaword .L46
	.uaword .L52
	.byte 0x0e
	.uaword .L47
	.uaword .L51
	.byte 0x0d
	.ascii "next\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0x5b,0x02
	.byte 0x91,0x70,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x0f
	.ascii "HashLookup\0"
	.byte 0x01,0x02,0x01,0x6c
	.uaword HashLookup
	.uaword .L111
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x42,0x01
	.byte 0x00,0x00,0x02,0xd9,0x0c,0x00,0x00,0x02
	.byte 0xde
	.ascii "table\0"
	.byte 0x01,0x6b,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2d
	.ascii "key\0"
	.byte 0x01,0x6b,0x03,0x91,0xc8,0x00,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0x6d,0x02
	.byte 0x91,0x78,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0x6e,0x02
	.byte 0x91,0x74,0x00,0x10,0x00,0x00,0x01,0x9e
	.byte 0x05,0x00,0x00,0x02,0xd9,0x0b
	.ascii "HashInsert\0"
	.byte 0x01,0x02,0x01,0x88
	.uaword HashInsert
	.uaword .L172
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x03,0x54
	.byte 0x0c,0x00,0x00,0x01,0xce
	.ascii "table\0"
	.byte 0x01,0x87,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2d
	.ascii "key\0"
	.byte 0x01,0x87,0x03,0x91,0xc8,0x00,0x0c,0x00
	.byte 0x00,0x01,0x42
	.ascii "data\0"
	.byte 0x01,0x87,0x03,0x91,0xcc,0x00,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0x8a,0x02
	.byte 0x91,0x7c,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0x8b,0x02
	.byte 0x91,0x78,0x00,0x0b
	.ascii "HashRemove\0"
	.byte 0x01,0x02,0x01,0xae
	.uaword HashRemove
	.uaword .L238
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x03,0xc5
	.byte 0x0c,0x00,0x00,0x01,0xce
	.ascii "table\0"
	.byte 0x01,0xad,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2d
	.ascii "key\0"
	.byte 0x01,0xad,0x03,0x91,0xc8,0x00,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0xaf,0x02
	.byte 0x91,0x7c,0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0xb0,0x02
	.byte 0x91,0x78,0x0d
	.ascii "prev\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0xb0,0x02
	.byte 0x91,0x74,0x00,0x0f
	.ascii "HashFirstEntry\0"
	.byte 0x01,0x02,0x01,0xd1
	.uaword HashFirstEntry
	.uaword .L274
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x2d,0x01
	.byte 0x00,0x00,0x04,0x0e,0x0c,0x00,0x00,0x04
	.byte 0x13
	.ascii "table\0"
	.byte 0x01,0xd0,0x03,0x91,0xc4,0x00,0x0d
	.ascii "pos\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0xd2,0x02
	.byte 0x91,0x78,0x00,0x10,0x00,0x00,0x01,0x9e
	.byte 0x05,0x00,0x00,0x04,0x0e,0x0b
	.ascii "HashPrint\0"
	.byte 0x01,0x02,0x01,0xe1
	.uaword HashPrint
	.uaword .L318
	.byte 0x01,0x6e,0x01,0x01,0x00,0x00,0x04,0x85
	.byte 0x0c,0x00,0x00,0x04,0x8a
	.ascii "table\0"
	.byte 0x01,0xe0,0x03,0x91,0xc4,0x00,0x0d
	.ascii "i\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0xe2,0x02
	.byte 0x91,0x7c,0x0e
	.uaword .L287
	.uaword .L316
	.byte 0x0e
	.uaword .L293
	.uaword .L313
	.byte 0x0e
	.uaword .L294
	.uaword .L312
	.byte 0x0d
	.ascii "entry\0"
	.byte 0x00,0x00,0x01,0x47,0x01,0x01,0xe5,0x02
	.byte 0x91,0x74,0x00,0x00,0x00,0x00,0x10,0x00
	.byte 0x00,0x01,0x9e,0x05,0x00,0x00,0x04,0x85
	.byte 0x0f
	.ascii "HashFindFreeKeyBlock\0"
	.byte 0x01,0x02,0x01,0xf6
	.uaword HashFindFreeKeyBlock
	.uaword .L383
	.byte 0x01,0x6e,0x01,0x00,0x00,0x01,0x2d,0x01
	.byte 0x00,0x00,0x05,0x4c,0x0c,0x00,0x00,0x05
	.byte 0x51
	.ascii "table\0"
	.byte 0x01,0xf5,0x03,0x91,0xc4,0x00,0x0c,0x00
	.byte 0x00,0x01,0x2d
	.ascii "numKeys\0"
	.byte 0x01,0xf5,0x03,0x91,0xc8,0x00,0x0d
	.ascii "maxKey\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0xf7,0x02
	.byte 0x91,0x78,0x0e
	.uaword .L325
	.uaword .L381
	.byte 0x0e
	.uaword .L334
	.uaword .L380
	.byte 0x0e
	.uaword .L335
	.uaword .L379
	.byte 0x0d
	.ascii "freeCount\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0xfe,0x02
	.byte 0x91,0x74,0x0d
	.ascii "freeStart\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0xff,0x02
	.byte 0x91,0x70,0x11
	.ascii "key\0"
	.byte 0x00,0x00,0x01,0x2d,0x01,0x01,0x01,0x00
	.byte 0x02,0x91,0x6c,0x00,0x00,0x00,0x00,0x10
	.byte 0x00,0x00,0x01,0x9e,0x05,0x00,0x00,0x05
	.byte 0x4c,0x03
	.ascii "char\0"
	.byte 0x06,0x01,0x10,0x00,0x00,0x05,0x56,0x05
	.byte 0x00,0x00,0x05,0x5e,0x03
	.ascii "int\0"
	.byte 0x05,0x04,0x12
	.ascii "printf\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x05,0x68,0x01
	.byte 0x00,0x00,0x05,0x8a,0x13,0x00,0x00,0x05
	.byte 0x63,0x14,0x00,0x15
	.ascii "free\0"
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x05,0x9e
	.byte 0x13,0x00,0x00,0x01,0x42,0x00,0x12
	.ascii "calloc\0"
	.byte 0x01,0x01,0x01,0x00,0x00,0x01,0x42,0x01
	.byte 0x00,0x00,0x05,0xbd,0x13,0x00,0x00,0x01
	.byte 0x21,0x13,0x00,0x00,0x01,0x21,0x00,0x10
	.byte 0x00,0x00,0x05,0x56,0x05,0x00,0x00,0x05
	.byte 0xbd,0x10,0x00,0x00,0x05,0x56,0x05,0x00
	.byte 0x00,0x05,0xc7,0x16
	.ascii "__assert\0"
	.byte 0x01,0x01,0x01,0x01,0x13,0x00,0x00,0x05
	.byte 0xc2,0x13,0x00,0x00,0x05,0xcc,0x13,0x00
	.byte 0x00,0x05,0x68,0x00,0x00,0x00,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_line
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=0, off=105, siz=4, lab1=NewHashTable, lab2=, loff=0
!   reloc[1]: knd=0, off=112, siz=4, lab1=.L16, lab2=, loff=0
!   reloc[2]: knd=0, off=124, siz=4, lab1=.L17, lab2=, loff=0
!   reloc[3]: knd=0, off=137, siz=4, lab1=DeleteHashTable, lab2=, loff=0
!   reloc[4]: knd=0, off=144, siz=4, lab1=.L24, lab2=, loff=0
!   reloc[5]: knd=0, off=156, siz=4, lab1=.L32, lab2=, loff=0
!   reloc[6]: knd=0, off=164, siz=4, lab1=.L39, lab2=, loff=0
!   reloc[7]: knd=0, off=172, siz=4, lab1=.L44, lab2=, loff=0
!   reloc[8]: knd=0, off=180, siz=4, lab1=.L48, lab2=, loff=0
!   reloc[9]: knd=0, off=188, siz=4, lab1=.L49, lab2=, loff=0
!   reloc[10]: knd=0, off=196, siz=4, lab1=.L50, lab2=, loff=0
!   reloc[11]: knd=0, off=204, siz=4, lab1=.L53, lab2=, loff=0
!   reloc[12]: knd=0, off=214, siz=4, lab1=.L58, lab2=, loff=0
!   reloc[13]: knd=0, off=224, siz=4, lab1=.L61, lab2=, loff=0
!   reloc[14]: knd=0, off=234, siz=4, lab1=.L62, lab2=, loff=0
!   reloc[15]: knd=0, off=247, siz=4, lab1=HashLookup, lab2=, loff=0
!   reloc[16]: knd=0, off=254, siz=4, lab1=.L69, lab2=, loff=0
!   reloc[17]: knd=0, off=266, siz=4, lab1=.L76, lab2=, loff=0
!   reloc[18]: knd=0, off=274, siz=4, lab1=.L83, lab2=, loff=0
!   reloc[19]: knd=0, off=282, siz=4, lab1=.L84, lab2=, loff=0
!   reloc[20]: knd=0, off=290, siz=4, lab1=.L89, lab2=, loff=0
!   reloc[21]: knd=0, off=298, siz=4, lab1=.L95, lab2=, loff=0
!   reloc[22]: knd=0, off=306, siz=4, lab1=.L99, lab2=, loff=0
!   reloc[23]: knd=0, off=314, siz=4, lab1=.L103, lab2=, loff=0
!   reloc[24]: knd=0, off=322, siz=4, lab1=.L106, lab2=, loff=0
!   reloc[25]: knd=0, off=332, siz=4, lab1=.L109, lab2=, loff=0
!   reloc[26]: knd=0, off=342, siz=4, lab1=.L110, lab2=, loff=0
!   reloc[27]: knd=0, off=355, siz=4, lab1=HashInsert, lab2=, loff=0
!   reloc[28]: knd=0, off=362, siz=4, lab1=.L117, lab2=, loff=0
!   reloc[29]: knd=0, off=374, siz=4, lab1=.L124, lab2=, loff=0
!   reloc[30]: knd=0, off=382, siz=4, lab1=.L133, lab2=, loff=0
!   reloc[31]: knd=0, off=390, siz=4, lab1=.L136, lab2=, loff=0
!   reloc[32]: knd=0, off=398, siz=4, lab1=.L139, lab2=, loff=0
!   reloc[33]: knd=0, off=406, siz=4, lab1=.L140, lab2=, loff=0
!   reloc[34]: knd=0, off=414, siz=4, lab1=.L145, lab2=, loff=0
!   reloc[35]: knd=0, off=422, siz=4, lab1=.L151, lab2=, loff=0
!   reloc[36]: knd=0, off=430, siz=4, lab1=.L155, lab2=, loff=0
!   reloc[37]: knd=0, off=438, siz=4, lab1=.L156, lab2=, loff=0
!   reloc[38]: knd=0, off=446, siz=4, lab1=.L160, lab2=, loff=0
!   reloc[39]: knd=0, off=454, siz=4, lab1=.L163, lab2=, loff=0
!   reloc[40]: knd=0, off=464, siz=4, lab1=.L166, lab2=, loff=0
!   reloc[41]: knd=0, off=474, siz=4, lab1=.L167, lab2=, loff=0
!   reloc[42]: knd=0, off=482, siz=4, lab1=.L168, lab2=, loff=0
!   reloc[43]: knd=0, off=490, siz=4, lab1=.L169, lab2=, loff=0
!   reloc[44]: knd=0, off=498, siz=4, lab1=.L170, lab2=, loff=0
!   reloc[45]: knd=0, off=506, siz=4, lab1=.L171, lab2=, loff=0
!   reloc[46]: knd=0, off=519, siz=4, lab1=HashRemove, lab2=, loff=0
!   reloc[47]: knd=0, off=526, siz=4, lab1=.L178, lab2=, loff=0
!   reloc[48]: knd=0, off=538, siz=4, lab1=.L185, lab2=, loff=0
!   reloc[49]: knd=0, off=546, siz=4, lab1=.L192, lab2=, loff=0
!   reloc[50]: knd=0, off=554, siz=4, lab1=.L193, lab2=, loff=0
!   reloc[51]: knd=0, off=562, siz=4, lab1=.L194, lab2=, loff=0
!   reloc[52]: knd=0, off=570, siz=4, lab1=.L199, lab2=, loff=0
!   reloc[53]: knd=0, off=578, siz=4, lab1=.L205, lab2=, loff=0
!   reloc[54]: knd=0, off=586, siz=4, lab1=.L211, lab2=, loff=0
!   reloc[55]: knd=0, off=594, siz=4, lab1=.L215, lab2=, loff=0
!   reloc[56]: knd=0, off=602, siz=4, lab1=.L221, lab2=, loff=0
!   reloc[57]: knd=0, off=612, siz=4, lab1=.L225, lab2=, loff=0
!   reloc[58]: knd=0, off=620, siz=4, lab1=.L226, lab2=, loff=0
!   reloc[59]: knd=0, off=628, siz=4, lab1=.L230, lab2=, loff=0
!   reloc[60]: knd=0, off=636, siz=4, lab1=.L231, lab2=, loff=0
!   reloc[61]: knd=0, off=644, siz=4, lab1=.L234, lab2=, loff=0
!   reloc[62]: knd=0, off=654, siz=4, lab1=.L237, lab2=, loff=0
!   reloc[63]: knd=0, off=669, siz=4, lab1=HashFirstEntry, lab2=, loff=0
!   reloc[64]: knd=0, off=676, siz=4, lab1=.L244, lab2=, loff=0
!   reloc[65]: knd=0, off=688, siz=4, lab1=.L252, lab2=, loff=0
!   reloc[66]: knd=0, off=696, siz=4, lab1=.L261, lab2=, loff=0
!   reloc[67]: knd=0, off=704, siz=4, lab1=.L264, lab2=, loff=0
!   reloc[68]: knd=0, off=712, siz=4, lab1=.L269, lab2=, loff=0
!   reloc[69]: knd=0, off=722, siz=4, lab1=.L272, lab2=, loff=0
!   reloc[70]: knd=0, off=732, siz=4, lab1=.L273, lab2=, loff=0
!   reloc[71]: knd=0, off=745, siz=4, lab1=HashPrint, lab2=, loff=0
!   reloc[72]: knd=0, off=752, siz=4, lab1=.L280, lab2=, loff=0
!   reloc[73]: knd=0, off=764, siz=4, lab1=.L288, lab2=, loff=0
!   reloc[74]: knd=0, off=772, siz=4, lab1=.L295, lab2=, loff=0
!   reloc[75]: knd=0, off=780, siz=4, lab1=.L300, lab2=, loff=0
!   reloc[76]: knd=0, off=788, siz=4, lab1=.L304, lab2=, loff=0
!   reloc[77]: knd=0, off=796, siz=4, lab1=.L306, lab2=, loff=0
!   reloc[78]: knd=0, off=804, siz=4, lab1=.L309, lab2=, loff=0
!   reloc[79]: knd=0, off=814, siz=4, lab1=.L314, lab2=, loff=0
!   reloc[80]: knd=0, off=824, siz=4, lab1=.L317, lab2=, loff=0
!   reloc[81]: knd=0, off=839, siz=4, lab1=HashFindFreeKeyBlock, lab2=, loff=0
!   reloc[82]: knd=0, off=846, siz=4, lab1=.L324, lab2=, loff=0
!   reloc[83]: knd=0, off=858, siz=4, lab1=.L327, lab2=, loff=0
!   reloc[84]: knd=0, off=866, siz=4, lab1=.L331, lab2=, loff=0
!   reloc[85]: knd=0, off=874, siz=4, lab1=.L336, lab2=, loff=0
!   reloc[86]: knd=0, off=884, siz=4, lab1=.L337, lab2=, loff=0
!   reloc[87]: knd=0, off=892, siz=4, lab1=.L339, lab2=, loff=0
!   reloc[88]: knd=0, off=900, siz=4, lab1=.L348, lab2=, loff=0
!   reloc[89]: knd=0, off=908, siz=4, lab1=.L352, lab2=, loff=0
!   reloc[90]: knd=0, off=916, siz=4, lab1=.L353, lab2=, loff=0
!   reloc[91]: knd=0, off=924, siz=4, lab1=.L359, lab2=, loff=0
!   reloc[92]: knd=0, off=934, siz=4, lab1=.L362, lab2=, loff=0
!   reloc[93]: knd=0, off=942, siz=4, lab1=.L366, lab2=, loff=0
!   reloc[94]: knd=0, off=950, siz=4, lab1=.L375, lab2=, loff=0
!   reloc[95]: knd=0, off=960, siz=4, lab1=.L378, lab2=, loff=0
!   reloc[96]: knd=0, off=970, siz=4, lab1=.L382, lab2=, loff=0
	.section ".debug_line"
	.byte 0x00,0x00,0x03,0xd0,0x00,0x02,0x00,0x00
	.byte 0x00,0x5c,0x04,0x00,0xff,0x04,0x0a,0x00
	.byte 0x01,0x01,0x01,0x01,0x00,0x00,0x00,0x01
	.byte 0x2f,0x68,0x6f,0x6d,0x65,0x2f,0x66,0x61
	.byte 0x63,0x75,0x6c,0x74,0x79,0x2f,0x6b,0x6f
	.byte 0x70,0x70,0x65,0x6c,0x2f,0x74,0x65,0x61
	.byte 0x63,0x68,0x2f,0x67,0x70,0x63,0x6f,0x6d
	.byte 0x2f,0x67,0x70,0x75,0x70,0x2f,0x72,0x73
	.byte 0x69,0x6d,0x2f,0x6d,0x65,0x73,0x61,0x2f
	.byte 0x6e,0x6f,0x2d,0x6f,0x70,0x74,0x00,0x47
	.byte 0x4c,0x00,0x00,0x68,0x61,0x73,0x68,0x2e
	.byte 0x63,0x00,0x01,0x00,0x00,0x67,0x6c,0x2e
	.byte 0x68,0x00,0x02,0x00,0x00,0x00,0x00,0x05
	.byte 0x02
	.uaword NewHashTable
	.byte 0x00,0x05,0x02
	.uaword .L16
	.byte 0x06,0x03,0xcb,0x00,0x01,0x00,0x05,0x02
	.uaword .L17
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword DeleteHashTable
	.byte 0x00,0x05,0x02
	.uaword .L24
	.byte 0x06,0x03,0xd6,0x00,0x01,0x00,0x05,0x02
	.uaword .L32
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L39
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L44
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L48
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L49
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L50
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L53
	.byte 0x03,0x7d,0x01,0x00,0x05,0x02
	.uaword .L58
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L61
	.byte 0x03,0x08,0x01,0x00,0x05,0x02
	.uaword .L62
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword HashLookup
	.byte 0x00,0x05,0x02
	.uaword .L69
	.byte 0x06,0x03,0xef,0x00,0x01,0x00,0x05,0x02
	.uaword .L76
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L83
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L84
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L89
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L95
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L99
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L103
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L106
	.byte 0x03,0x7c,0x01,0x00,0x05,0x02
	.uaword .L109
	.byte 0x03,0x06,0x01,0x00,0x05,0x02
	.uaword .L110
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword HashInsert
	.byte 0x00,0x05,0x02
	.uaword .L117
	.byte 0x06,0x03,0x8c,0x01,0x01,0x00,0x05,0x02
	.uaword .L124
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L133
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L136
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L139
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L140
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L145
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L151
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L155
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L156
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L160
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L163
	.byte 0x03,0x7a,0x01,0x00,0x05,0x02
	.uaword .L166
	.byte 0x03,0x0a,0x01,0x00,0x05,0x02
	.uaword .L167
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L168
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L169
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L170
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L171
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword HashRemove
	.byte 0x00,0x05,0x02
	.uaword .L178
	.byte 0x06,0x03,0xb1,0x01,0x01,0x00,0x05,0x02
	.uaword .L185
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L192
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L193
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L194
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L199
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L205
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L211
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L215
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L221
	.byte 0x03,0x03,0x01,0x00,0x05,0x02
	.uaword .L225
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L226
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L230
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L231
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L234
	.byte 0x03,0x73,0x01,0x00,0x05,0x02
	.uaword .L237
	.byte 0x03,0x0f,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword HashFirstEntry
	.byte 0x00,0x05,0x02
	.uaword .L244
	.byte 0x06,0x03,0xd2,0x01,0x01,0x00,0x05,0x02
	.uaword .L252
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L261
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L264
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L269
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L272
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L273
	.byte 0x0c,0x02,0x01,0x00,0x01,0x01,0x00,0x05
	.byte 0x02
	.uaword HashPrint
	.byte 0x00,0x05,0x02
	.uaword .L280
	.byte 0x06,0x03,0xe2,0x01,0x01,0x00,0x05,0x02
	.uaword .L288
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L295
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L300
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L304
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L306
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L309
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L314
	.byte 0x03,0x7e,0x01,0x00,0x05,0x02
	.uaword .L317
	.byte 0x03,0x07,0x01,0x02,0x01,0x00,0x01,0x01
	.byte 0x00,0x05,0x02
	.uaword HashFindFreeKeyBlock
	.byte 0x00,0x05,0x02
	.uaword .L324
	.byte 0x06,0x03,0xf6,0x01,0x01,0x00,0x05,0x02
	.uaword .L327
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L331
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L336
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L337
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L339
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L348
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L352
	.byte 0x0d,0x00,0x05,0x02
	.uaword .L353
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L359
	.byte 0x03,0x04,0x01,0x00,0x05,0x02
	.uaword .L362
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L366
	.byte 0x0c,0x00,0x05,0x02
	.uaword .L375
	.byte 0x03,0x76,0x01,0x00,0x05,0x02
	.uaword .L378
	.byte 0x03,0x0f,0x01,0x00,0x05,0x02
	.uaword .L382
	.byte 0x0d,0x02,0x01,0x00,0x01,0x01
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
	.byte 0x0b,0x01,0x11,0x01,0x12,0x01,0x00,0x00
	.byte 0x0f,0x2e,0x01,0x03,0x08,0x3f,0x0c,0x17
	.byte 0x0b,0x3a,0x0b,0x3b,0x0b,0x11,0x01,0x12
	.byte 0x01,0x40,0x0a,0x27,0x0c,0x49,0x13,0x88
	.byte 0x44,0x0b,0x01,0x13,0x00,0x00,0x10,0x26
	.byte 0x00,0x49,0x13,0x00,0x00,0x11,0x34,0x00
	.byte 0x03,0x08,0x49,0x13,0x17,0x0b,0x3a,0x0b
	.byte 0x3b,0x05,0x02,0x0a,0x00,0x00,0x12,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27
	.byte 0x0c,0x49,0x13,0x88,0x44,0x0b,0x01,0x13
	.byte 0x00,0x00,0x13,0x05,0x00,0x49,0x13,0x00
	.byte 0x00,0x14,0x18,0x00,0x00,0x00,0x15,0x2e
	.byte 0x01,0x03,0x08,0x3f,0x0c,0x3c,0x0c,0x27
	.byte 0x0c,0x88,0x44,0x0b,0x01,0x13,0x00,0x00
	.byte 0x16,0x2e,0x01,0x03,0x08,0x3f,0x0c,0x3c
	.byte 0x0c,0x27,0x0c,0x88,0x44,0x0b,0x00,0x00
	.byte 0x00
!  End sdCreateSection
!  Begin sdCreateSection : .debug_pubnames
!  Section Info: link_name/strtab=, entsize=0x1, adralign=0x1, flags=0x0
!  Section Data Blocks:
!   reloc[0]: knd=2, off=6, siz=4, lab1=.debug_info, lab2=, loff=0
	.section ".debug_pubnames"
	.byte 0x00,0x00,0x00,0x9c,0x00,0x02
	.uaword %section_symbol(".debug_info")
	.byte 0x00,0x00,0x05,0xf4,0x00,0x00,0x00,0xff
	.byte 0x4e,0x65,0x77,0x48,0x61,0x73,0x68,0x54
	.byte 0x61,0x62,0x6c,0x65,0x00,0x00,0x00,0x01
	.byte 0xd3,0x44,0x65,0x6c,0x65,0x74,0x65,0x48
	.byte 0x61,0x73,0x68,0x54,0x61,0x62,0x6c,0x65
	.byte 0x00,0x00,0x00,0x02,0x74,0x48,0x61,0x73
	.byte 0x68,0x4c,0x6f,0x6f,0x6b,0x75,0x70,0x00
	.byte 0x00,0x00,0x02,0xe3,0x48,0x61,0x73,0x68
	.byte 0x49,0x6e,0x73,0x65,0x72,0x74,0x00,0x00
	.byte 0x00,0x03,0x54,0x48,0x61,0x73,0x68,0x52
	.byte 0x65,0x6d,0x6f,0x76,0x65,0x00,0x00,0x00
	.byte 0x03,0xc5,0x48,0x61,0x73,0x68,0x46,0x69
	.byte 0x72,0x73,0x74,0x45,0x6e,0x74,0x72,0x79
	.byte 0x00,0x00,0x00,0x04,0x18,0x48,0x61,0x73
	.byte 0x68,0x50,0x72,0x69,0x6e,0x74,0x00,0x00
	.byte 0x00,0x04,0x8f,0x48,0x61,0x73,0x68,0x46
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
	.byte 0x00,0x00,0x05,0xf4,0x00,0x00,0x01,0x2d
	.byte 0x47,0x4c,0x75,0x69,0x6e,0x74,0x00,0x00
	.byte 0x00,0x01,0x4c,0x48,0x61,0x73,0x68,0x45
	.byte 0x6e,0x74,0x72,0x79,0x00,0x00,0x00,0x01
	.byte 0x9e,0x48,0x61,0x73,0x68,0x54,0x61,0x62
	.byte 0x6c,0x65,0x00,0x00,0x00,0x00,0x00,0x00
	.byte 0x00,0x00
!  End sdCreateSection
