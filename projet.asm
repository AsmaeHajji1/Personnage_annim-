data segment 
x dw 100
y dw 50
L dw 30
x1 dw ?
y1 dw ?
x3 dw ?
x2 dw ?
y2 dw ?
f dw ?  ;1/4
f2 dw ? ;moitie de 1/4 <--1/8
L1 dw ? ;1/2
x4 dw ?
y4 dw ?
x5 dw ?
y5 dw ?
h dw 30  ;longueur du pied
L2 dw 6 ;pied bas gauche
Lp dw 7 ;pied bas droite
data ends 
assume ds:data,cs:code
code segment
defmod proc near 
 mov ah,0h
 int 10h
ret
defmod endp
putpixel proc near 
 mov ah,12
 int 10h
ret
putpixel endp
drawHL proc near
  add si,cx
tq:cmp cx,si
   jg fin
   call putpixel
   inc cx
   jmp tq
   fin: 
ret 
drawHL endp
drawVL proc near
  add si,dx
  tq1:cmp dx,si
   jg fin1
   call putpixel
   inc dx
   jmp tq1
fin1:  
ret 
drawVL endp
drawSquare proc near    ;Carre
 call defmod
      mov cx,x ;x
      mov dx,y  ;y
      mov si,L  ;L
      mov al,19
      call drawHL 
      mov cx,si ;x
      mov dx,y ;y
      mov si,L ;H
      call drawVL
      mov dx,si ;y
      mov cx,x;x
      mov si,L
      call drawHL
      mov cx,x
      mov dx,y
      mov si,L
      call drawVL
      ;mov x2,cx
      ;mov y2,dx
ret
drawSquare endp
draweyes proc near      ;Les yeux 
      mov ax,L
      mov bl,4
      div bl
      mov ah,0
      mov f,ax
      add cx,ax
      mov ax,f
      mov bl,3
      mul bl
      sub dx,ax
      mov al,11
      call putpixel
      mov ax,f
      add ax,ax
      add cx,ax
      mov al,11
      call putpixel
ret
draweyes endp
drawnose proc near 
    mov ax,f
    mov bl,2
    div bl
    mov ah,0
    mov f2,ax
    add dx,f2
    sub cx,f
    mov si,4
    call drawVL
ret
drawnose endp
drawmou proc near 
    mov cx,x
    add cx,f
    mov x4,cx
    mov dx,y 
    mov ax,f 
    mov bl,3
    mul bl
    mov ah,0
    add dx,ax
    mov y4,dx
    ;rectangle
    mov ax,f
    mov bl,2
    mul bl
    mov ah,0
    mov L1,ax
    mov si,L1
    mov al,9
    call drawHL
    mov cx,si
    mov si,2
    call drawVL
    mov cx,x4
    mov dx,y4
    mov si,2
    call drawVL
    mov si,L1
    call drawHL
ret 
drawmou endp
drawneck proc near
    mov cx,x 
    add cx,f 
    mov dx,y
    add dx,L
    mov si,5
    mov al,19
    call drawVL
    mov dx,y
    add dx,L
    add cx,L1 ;2fois *f
    mov si,5   
    call drawVL
ret
drawneck endp 
drawshoulders proc near
    mov cx,x 
    mov dx,y
    add dx,L
    add dx,5
    mov si,L
    call drawHL
    ;right
    mov x2,cx
    mov y2,dx
    mov si,10
    call drawOR  ;1ere ligne
    mov cx,x2
    mov dx,y2
    add dx,7
    mov si,10
     ;Les coordonnees de 2 eme ligne du main droite
         mov y5,dx
         mov x5,cx
    call drawOR  ;2eme ligne
    sub dx,7
    mov si,5
    call drawVL
    mov cx,x5
    mov dx,y5
    mov si,L
    call drawVL
    ;left
    mov cx,x     ;1ere ligne 
    mov dx,y
    add dx,L
    add dx,5
    mov ax,10    ; mov si,20 double de la main droite
    mov bl,2
    mul bl 
    mov si,ax
    mov al,19
    call drawOL
    mov cx,x     ;2eme ligne
    mov dx,y
    add dx,L
    add dx,12
    ;Les coordonnees de 2 eme ligne du main gauche 
         mov y5,dx
         mov x5,cx
    mov ax,10    ; mov si,20 double de la main droite
    mov bl,2
    mul bl 
    mov si,ax
    mov al,19
    call drawOL 
    sub dx,7
    mov si,5
    call drawVL
    mov cx,x5
    mov dx,y5
    mov si,L
    call drawVL
    mov x5,cx
    mov dx,si
    mov y5,dx
    mov si,L
    call drawHL 
    mov cx,x5    ;Les pieds gauches
    add cx,f
    mov dx,y5
    mov si,h
    call drawVL
    mov si,Lp
    call drawHL  ;pied bas
    mov dx,y5
    mov cx,x5
    add cx,L1
    mov si,h
    call drawVL
    add cx,f      ;pieds droites
    mov dx,y5
    mov si,h
    call drawVL
    mov si,L2      ;pied bas
    call drawHL
    mov dx,y5
    mov cx,x5
    add cx,L1
    add cx,f
    add cx,6
    mov si,h
    call drawVL   
ret
drawshoulders endp 
drawOR proc near
    add si,cx
    tqOR:cmp cx,si
         jg ftqOR
         call putpixel
         inc dx 
         inc dx  ;dx<--dx+2
         inc cx
         jmp tqOR
     ftqOR:
ret 
drawOR endp
drawOL proc near
  add si,dx
  OL:cmp dx,si
  jg fOL
  call putpixel
  inc dx
  inc dx
  dec cx
  jmp OL
fOL:
ret 
drawOL endp
drawAVATAR proc near
  mov al,13
  call drawSquare
  call draweyes
  call drawnose
  call drawmou
  call drawneck
  call drawshoulders
ret 
drawAVATAR endp
main:
     mov ax,data 
     mov ds,ax
     call drawAVATAR
   deb:mov ah,01h
       int 21h
       cmp al,77   ;Fleche Droite
       je droite   
       cmp al,48h  ;Fleche Haut
       je haut
       cmp al,50h  ;Fleche Bas
       je bas
       cmp al,75   ;Fleche Gauche
       je gauche   
       cmp al,32
       je sauter
       jmp deb
droite:add x,2
        call drawAVATAR
        jmp deb
   haut:sub y,2
        call drawAVATAR
        jmp deb
 gauche:sub x,2
        call drawAVATAR
        jmp deb
    bas:add y,2
        call drawAVATAR
        jmp deb
 sauter:sub y,10
        call drawAVATAR
        add x,10
        call drawAVATAR
        sub y,10
        call drawAVATAR
        add x,10
        call drawAVATAR
        add y,5
        call drawAVATAR
        add y,5
        call drawAVATAR
        add y,5
        call drawAVATAR
        add y,5
        call drawAVATAR
        jmp deb
code ends
end main