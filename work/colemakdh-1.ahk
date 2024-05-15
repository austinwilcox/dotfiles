#Requires AutoHotkey v2.0

;qwerty-to-colemak.ahk


;Colemak Keyboard Layout
;---------------------------------------------
;  ~  !  @  #  $  %  ^  &  *  (  )  _  +  ____
;  `  1  2  3  4  5  6  7  8  9  0  -  =   BS
; ___                                {  }  |
; Tab  q  w  f  p  g  j  l  u  y  ;  [  ]  \
; ____                                "  _____
; Caps  a  r  s  t  d  h  n  e  i  o  '  Enter
; _____                       <  >  ?  _______
; Shift  z  x  c  v  b  k  m  ,  .  /   Shift

;Qwerty Keyboard Layout
;---------------------------------------------
;  ~  !  @  #  $  %  ^  &  *  (  )  _  +  ____
;  `  1  2  3  4  5  6  7  8  9  0  -  =   BS
; ___                                {  }  |
; Tab  q  w  e  r  t  y  u  i  o  p  [  ]  \
; ____                             :  "  _____
; Caps  a  s  d  f  g  h  j  k  l  ;  '  Enter
; _____                       <  >  ?  _______
; Shift  z  x  c  v  b  n  m  ,  .  /   Shift


capslock::Esc
;   q  w  e  r  t  y  u  i  o  p  [  ]  \
;=> q  w  f  p  b  j  l  u  y  ;  [  ]  \
e::f
r::p
t::b
y::j
u::l
i::u
o::y
p::;

;   a  s  d  f  g  h  j  k  l  ;  '
;=> a  r  s  t  d  h  n  e  i  o  '
s::r
d::s
f::t
h::m
j::n
k::e
l::i
`;::o

;   z  x  c  v  b  n  m  ,  .  /
;=> z  x  c  v  b  h  m  ,  .  /
v::d
n::k
m::h
b::v

