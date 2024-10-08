JsOsaDAS1.001.00bplist00�Vscripto� / /   t o   r u n   i n   T e r m i n a l : 
 / /   %   c d   / U s e r s / p r o t o o l s / D e s k t o p / t e s t S c r i p t s 
 / /   %   o s a s c r i p t   j x a P r e r o l l O n . s c p t   6 + 0 0 
 
 O b j C . i m p o r t ( " F o u n d a t i o n " ) ; 
   
 c o n s t   a r g s   =   $ . N S P r o c e s s I n f o . p r o c e s s I n f o . a r g u m e n t s ; 
 / /   f r o m   c o n s o l e : 
 / /   a r g s [ 0 . . 3 ]   a r e   f i l e n a m e ,   " / u s r / b i n / o s a s c r i p t " ,   " - l " ,   " J a v a S c r i p t "   
 / /   f r o m   o s a S c r i p t   i n   o u r   p r o g r a m : 
 / /   @ " / u s r / b i n / o s a s c r i p t , / U s e r s / p r o t o o l s / L i b r a r y / S c r i p t s / j x a C u t A n d P a s t e . s c p t , * 1 2 3 4 "   	 
 / / c o n s o l e . l o g ( " a r g s . c o u n t " , a r g s . c o u n t ) ; 	 / /   n o t e   ' c o u n t ' ,   O b j e c t i v e   C - l i k e 
 / / 
 v a r   a r g v   =   [ ] ; 
 v a r   r e s u l t   =   - 1 ; 	 / /   a s s u m e   f a i l u r e 
 
 i f   ( a r g s . c o u n t   >   1 ) { 
 
 	 v a r   s t a r t I n d e x   =   a r g s . j s [ 1 ] . j s   = =   ( ' - l ' )   ?   4   :   2 ; 	 / /   a s s u m e   w e   a r e   c a l l e d   f r o m   t h e   c o m m a n d   l i n e 
 
 	 / / c o n s o l e . l o g ( ' s t a r t I n d e x ' ,   s t a r t I n d e x ) ; 
 
 	 f o r ( l e t   i   =   s t a r t I n d e x ;   i   <   a r g s . c o u n t ;   i + + ) { 
 	 	 a r g v . p u s h ( O b j C . u n w r a p ( a r g s . o b j e c t A t I n d e x ( i ) ) ) ; 
 	 } 
 } 
 
 / / a r g v [ 0 ]   =   ' 6 + 0 0 ' ; 
 
 i f ( a r g v . l e n g t h   >   0 ) { 
 
 	 r e s u l t   =   p r e r o l l O n ( a r g v [ 0 ] ) ; 
 } 
 
 r e s u l t ; 
 
 f u n c t i o n   p r e r o l l O n ( p r e r o l l ) { 
 / /   l i k e   ' 6 + 0 0 '   o r   ' 0 0 : 0 0 : 0 4 : 0 0 ' 
 
 	 l e t   i s F e e t   =   p r e r o l l . i n c l u d e s ( ' + ' ) ; 
 	 
 	 m a i n C o u n t e r F o r m a t ( i s F e e t ) ; 
 	 s h o w T r a n s p o r t ( ) ; 
 	 s e t P r e r o l l ( p r e r o l l ) ; 
 	 
 } 
 
 f u n c t i o n   m a i n C o u n t e r F o r m a t ( i s F e e t ) { 
 	 c o n s t   a p p   =   A p p l i c a t i o n ( ' S y s t e m   E v e n t s ' ) ; 
 	 c o n s t   p t   =   a p p . p r o c e s s e s [ ' P r o   T o o l s ' ] ; 
 
 	 p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " W i n d o w " ] . m e n u s [ " W i n d o w " ] . m e n u I t e m s [ " E d i t " ] . c l i c k ( ) ; 
 	 p t . f r o n t m o s t   =   t r u e ; 
 
 	 i f ( i s F e e t ) { 
 	 	 p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " V i e w " ] . m e n u s [ " V i e w " ] . m e n u I t e m s [ " M a i n   C o u n t e r " ] . m e n u s [ " M a i n   C o u n t e r " ] . m e n u I t e m s [ " F e e t + F r a m e s " ] . a c t i o n s [ " A X P r e s s " ] . p e r f o r m ( ) ; 
 	 } 
 	 e l s e { 
 	 	 p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " V i e w " ] . m e n u s [ " V i e w " ] . m e n u I t e m s [ " M a i n   C o u n t e r " ] . m e n u s [ " M a i n   C o u n t e r " ] . m e n u I t e m s [ " T i m e c o d e " ] . a c t i o n s [ " A X P r e s s " ] . p e r f o r m ( ) ; 
 	 } 
 
 } 
 f u n c t i o n   s h o w T r a n s p o r t ( ) { 
 	 c o n s t   a p p   =   A p p l i c a t i o n ( ' S y s t e m   E v e n t s ' ) ; 
 	 c o n s t   p t   =   a p p . p r o c e s s e s [ ' P r o   T o o l s ' ] ; 
 	 
 	 i f ( p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " W i n d o w " ] . m e n u s [ " W i n d o w " ] . m e n u I t e m s [ " T r a n s p o r t " ] . a t t r i b u t e s [ ' A X M e n u I t e m M a r k C h a r ' ] . v a l u e ( )   ! =   '' ' ) { 
 	 
 	 	 p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " W i n d o w " ] . m e n u s [ " W i n d o w " ] . m e n u I t e m s [ " T r a n s p o r t " ] . a c t i o n s [ " A X P r e s s " ] . p e r f o r m ( ) ; 
 	 } 
 
 	 
 	 i f ( p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " V i e w " ] . m e n u s [ " V i e w " ] . m e n u I t e m s [ ' T r a n s p o r t ' ] . m e n u s [ ' T r a n s p o r t ' ] . m e n u I t e m s [ ' E x p a n d e d ' ] . a t t r i b u t e s [ ' A X M e n u I t e m M a r k C h a r ' ] . v a l u e ( )   ! =   '' ' ) { 
 	 
 	 	 p t . m e n u B a r s [ 0 ] . m e n u B a r I t e m s [ " V i e w " ] . m e n u s [ " V i e w " ] . m e n u I t e m s [ ' T r a n s p o r t ' ] . m e n u s [ ' T r a n s p o r t ' ] . m e n u I t e m s [ ' E x p a n d e d ' ] . a c t i o n s [ " A X P r e s s " ] . p e r f o r m ( ) ; 
 	 } 
 } 
 f u n c t i o n   s e t P r e r o l l ( p r e r o l l ) { 
 
 / / w e   k n o w   t h a t   t h e   t r a n s p o r t   w i n d o w   i s   i n   f r o n t ,   a n d   t h a t   t h e   f t / t c   i s   s e t 
 	 c o n s t   a p p   =   A p p l i c a t i o n ( ' S y s t e m   E v e n t s ' ) ; 
 	 c o n s t   p t   =   a p p . p r o c e s s e s [ ' P r o   T o o l s ' ] ; 
 	 
 	 / /   T r a n s p o r t   V i e w   C l u s t e r 
 	 / /   f i n d   t h e   ' P r e - r o l l   A m o u n t '   t e x t   f i e l d 
 	 
 	 f o r ( l e t   i   =   0 ;   i   <   p t . w i n d o w s . l e n g t h ;   i + + ) { 
 	 
 	 	 l e t   g r   =   p t . w i n d o w s [ i ] . g r o u p s . n a m e ( ) ; 
 	 	 c o n s o l e . l o g ( g r ) ; 
 	 	 i f ( g r . i n c l u d e s ( ' T r a n s p o r t   V i e w   C l u s t e r ' ) ) { 
 	 	 
 	 	 	 p t . w i n d o w s [ i ] . g r o u p s [ ' T r a n s p o r t   V i e w   C l u s t e r ' ] . g r o u p s [ ' T r a n s p o r t   D i s p l a y ' ] . t e x t F i e l d s [ ' P r e - r o l l   A m o u n t ' ] . a c t i o n s [ ' A X P r e s s ' ] . p e r f o r m ( ) 
 	 	 	 
 	 	 	 / /   s p l i t   o n   ' + ' 
 	 	 	 / /   i f   2   i t e m s ,   f e e t / f r a m e 
 	 	 	 / /   i f   n o t ,   t c 
 	 	 	 l e t   f i e l d s   =   p r e r o l l . s p l i t ( ' + ' ) ; 
 	 	 	 
 	 	 	 i f ( f i e l d s . l e n g t h   = =   2 ) { 
 	 	 	 
 	 	 	 	 a p p . k e y s t r o k e ( f i e l d s [ 0 ] ) ; 	 / /   f e e t 
 	 	 	 	 a p p . k e y C o d e ( 1 2 4 ) ; 	 / /   r i g h t   a r r o w 
 	 	 	 	 a p p . k e y s t r o k e ( f i e l d s [ 1 ] ) ; 	 / /   f r a m e s 
 	 	 	 	 a p p . k e y s t r o k e ( ' \ r ' ) ; 
 	 	 	 } e l s e { 
 	 	 	 
 	 	 	 	 f i e l d s   =   p r e r o l l . s p l i t ( ' : ' ) ; 
 	 	 	 	 p r e r o l l   =   f i e l d s . j o i n ( ) ; 
 	 	 	 
 	 	 	 	 a p p . k e y s t r o k e ( p r e r o l l ) ; 
 	 	 	 	 a p p . k e y s t r o k e ( ' \ r ' ) ; 
 	 	 	 } 
 
 	 	 	 r e t u r n ; 
 	 	 } 
 	 
 	 } 
 }                              �jscr  ��ޭ